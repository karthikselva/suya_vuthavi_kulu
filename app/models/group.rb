class Group < ActiveRecord::Base
  
  attr_accessible :name, :saving_amount, :due_amount

  has_one :account, :as => :accountable
  has_many :groups_user
  has_many :users, :through => :groups_user
  has_many :monthly_buckets

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

  def final_balance(date)
    mb = MonthlyBucket.where(["group_id = ? and date >= ? and date <= ?", self.id, (date.to_date.beginning_of_month - 1).beginning_of_month, (date.to_date.beginning_of_month - 1).end_of_month]).first
    opening_balance = mb ? mb.final_balance : 0
  end 

  def bank_final_balance(date)
    mb = MonthlyBucket.where(["group_id = ? and date >= ? and date <= ?", self.id, (date.to_date.beginning_of_month - 1).beginning_of_month, (date.to_date.beginning_of_month - 1).end_of_month]).first
    opening_balance = mb ? mb.bank_final_balance : 0
  end  

  def update_final_balance(date)
    mb = MonthlyBucket.where(["group_id = ? and date >= ? and date <= ?", self.id, (date.to_date.beginning_of_month - 1).beginning_of_month, (date.to_date.beginning_of_month - 1).end_of_month]).first
    opening_balance = mb ? mb.final_balance : 0

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

    deposit_amount = Bank.get_bank_deposit_amount(date,self.account.id)
    withdraw_amount = Bank.get_bank_withdraw_amount(date,self.account.id)

    tot = 0
    for debit_detail in debit_details.to_a
      tot += debit_detail[1]["principle_debit"]
    end

    for expense in self.get_expenses(date)
      tot += expense.other_amount
    end

    amount = (opening_balance + total_hash["total"] + withdraw_amount) - (tot + deposit_amount)
    monthly_bucket = MonthlyBucket.where(["group_id = ? and date >= ? and date <= ?", self.id, date.beginning_of_month, date.end_of_month]).first
    if monthly_bucket
      monthly_bucket.final_balance = amount
      monthly_bucket.save
    else
      monthly_bucket = MonthlyBucket.new(:group_id => self.id, :date => date.to_date, :final_balance => amount)
      monthly_bucket.save
    end  
    # self.final_balance = self.final_balance.to_f + (total_hash["total"] - tot)
    # self.save
  end

  def update_bank_final_balance(date,another_acc_id)
    mb = MonthlyBucket.where(["group_id = ? and date >= ? and date <= ?", self.id, (date.to_date.beginning_of_month - 1).beginning_of_month, (date.to_date.beginning_of_month - 1).end_of_month]).first
    opening_balance = mb ? mb.bank_final_balance : 0
    amount = (opening_balance + Bank.get_bank_deposit_amount(date,another_acc_id) + Bank.get_bank_interest_amount(date,another_acc_id)) - Bank.get_bank_withdraw_amount(date,another_acc_id)
    monthly_bucket = MonthlyBucket.where(["group_id = ? and date >= ? and date <= ?", self.id, date.beginning_of_month, date.end_of_month]).first
    if monthly_bucket
      monthly_bucket.bank_final_balance = amount
      monthly_bucket.save
    else
      monthly_bucket = MonthlyBucket.new(:group_id => self.id, :date => date.to_date, :bank_final_balance => amount)
      monthly_bucket.save
    end

    # self.bank_final_balance = self.bank_final_balance.to_f + Bank.get_bank_deposit_amount(date,another_acc_id) - Bank.get_bank_withdraw_amount(date,another_acc_id)
    # self.save
  end

  # cron job scheduled to update_final_balance
  def self.update_final_balance(date,group)
    group ? group.update_final_balance(date) : Group.all.each{|group| group.update_final_balance(date) }
  end

  def self.update_bank_final_balance(date,group)
    group ? group.update_bank_final_balance(date, group.account.id) : Group.all.each{|group| group.update_bank_final_balance(date, group.account.id) }
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
    intr - base_group.monthly_decision_book(date, self.account.id)["interest_credit"].to_f
  end

end
