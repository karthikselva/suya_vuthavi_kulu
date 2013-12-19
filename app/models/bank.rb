class Bank < ActiveRecord::Base

  attr_accessible :bank_name, :branch, :account_name, :account_number
  
  has_one :account, :as => :accountable

  after_save :create_account
  
  def create_account
    Account.make_account(self)
  end

  def self.get_bank_withdraw_details(date, another_acc_id)
    bank_acc_ids = Account.where(:accountable_type => "Bank").collect{|s| s.id }
    from_date = date.to_date.beginning_of_month
    to_date = date.to_date.end_of_month
    AccountTranDetail.where(["from_Account_id in(?) and to_account_id = ? and transaction_date >= ? and transaction_date <= ?", bank_acc_ids, another_acc_id, from_date, to_date])
  end	

  def self.get_bank_deposit_details(date, another_acc_id)
    bank_acc_ids = Account.where(:accountable_type => "Bank").collect{|s| s.id }
    from_date = date.to_date.beginning_of_month
    to_date = date.to_date.end_of_month
    AccountTranDetail.where(["from_account_id =? and to_account_id in(?) and transaction_date >= ? and transaction_date <= ?", another_acc_id, bank_acc_ids, from_date, to_date])
  end

  def self.get_bank_withdraw_amount(date, another_acc_id)
    self.get_bank_withdraw_details(date, another_acc_id).inject(0){|acc, obj| acc + (obj.principle_credit.to_f) }
  end	

  def self.get_bank_deposit_amount(date, another_acc_id)
    self.get_bank_deposit_details(date, another_acc_id).inject(0){|acc, obj| acc + (obj.principle_debit.to_f) } # + obj.other_amount.to_f
  end

  def self.get_bank_interest_amount(date,another_acc_id)
    self.get_bank_withdraw_details(date, another_acc_id).inject(0){|acc, obj| acc + (obj.other_amount.to_f) }
  end  

end
