class Group < ActiveRecord::Base
  
  attr_accessible :name, :saving_amount, :due_amount

  has_one :account, :as => :accountable
  has_many :groups_users
  has_many :users, :through => :groups_users

  after_save :create_account

  def self.balance_principal_and_interest(base_group, selected_group, date)
    {
      "principle_credit" => selected_group.outstanding_balance(base_group, date.to_date),
      "interest_credit" => selected_group.get_balance_interest(base_group, date.to_date)
    }
  end  

  def create_account
  	Account.make_account(self)
  end

  def monthly_decision_book(tran_date, to_account_id)
    self.account.monthly_decision_book(tran_date, to_account_id)
  end

  def monthly_decision_book_debit(tran_date, to_account_id)
    self.account.monthly_decision_book_debit(tran_date, to_account_id)
  end

  def last_month_outstanding_Principal(base_group, date)
    account_ids = [self.account.id, base_group.account.id]
    tran_date = date.beginning_of_month - 1
    from_date = tran_date.to_date.beginning_of_month
    to_date = tran_date.to_date.end_of_month

    old_gtd = GroupTransTrack.where(["from_account_id in(?) and to_account_id in(?) and transaction_date >= ? and transaction_date <= ?", account_ids, account_ids, from_date, to_date]).order("id desc").first
    bal_amount = old_gtd ? [[old_gtd.from_account_id, old_gtd.from_to_outs_balance],[old_gtd.to_account_id, old_gtd.to_from_outs_balance]] : [[account_ids[0], 0],[account_ids[1], 0]]
    bal_amount.assoc(account_ids[0])[1]
  end

  def outstanding_balance(base_group, date)
    account_ids = [self.account.id, base_group.account.id]
    old_gtd = GroupTransTrack.where(["from_account_id in(?) and to_account_id in(?)", account_ids, account_ids]).order("id desc").first
    bal_amount = old_gtd ? [[old_gtd.from_account_id, old_gtd.from_to_outs_balance],[old_gtd.to_account_id, old_gtd.to_from_outs_balance]] : [[account_ids[0], 0],[account_ids[1], 0]]
    bal_amount.assoc(account_ids[0])[1]
  end

  def get_current_month_interest(base_group, date)
    pa = last_month_outstanding_Principal(base_group, date)
    get_interest(pa)
  end

  def get_balance_interest(base_group, date)
    intr = get_current_month_interest(base_group, date)
    intr - self.monthly_decision_book(date, base_group.account.id)["interest_credit"].to_f
  end

  def get_expenses(tran_date)
    from_date = tran_date.to_date.beginning_of_month
    to_date = tran_date.to_date.end_of_month
    AccountTranDetail.where(["from_account_id = ? and to_account_id = ? and transaction_date >= ? and transaction_date <= ?", self.account.id, EXPENSES_ACC_ID, from_date, to_date])
  end  

  def update_final_balance(date)
    total_hash = {"saving" => 0, "due" => 0, "principle_credit" => 0, "interest_credit" => 0, "other_amount" => 0, "total" => 0} 
    debit_details = {} 
    for member in self.users
      details = member.monthly_decision_book(date.to_date) 
      total_hash["saving"] += details["saving"] 
      total_hash["due"] += details["due"] 
      total_hash["principle_credit"] += details["principle_credit"] 
      total_hash["interest_credit"] += details["interest_credit"] 
      total_hash["other_amount"] += details["other_amount"] 
      total = details["saving"] + details["due"] + details["other_amount"] + details["principle_credit"] + details["interest_credit"] 
      total_hash["total"] += total 
      debit_details.merge!({member.full_name => member.monthly_decision_book_debit(date.to_date)}) 
      debit_details.delete_if{|k,v| v["principle_debit"] == 0 } 
    end 

    tot = 0
    for debit_detail in debit_details.to_a
      tot += debit_detail[1]["principle_debit"]
    end

    for expense in self.get_expenses(date)
      tot += expense.other_amount
    end

    self.final_balance = self.final_balance.to_f + (total_hash["total"] - tot)
    self.save
  end

  # cron job scheduled to update_final_balance
  def self.update_final_balance(date)
    Group.all.each{|group| group.update_final_balance(date) }
  end

end
