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
    intr - base_group.monthly_decision_book(date, self.account.id)["interest_credit"].to_f
  end

end
