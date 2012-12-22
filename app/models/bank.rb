class Bank < ActiveRecord::Base

  attr_accessible :bank_name, :branch, :account_name, :account_number
  
  has_one :account, :as => :accountable

  after_save :create_account
  
  def create_account
    Account.make_account(self)
  end

end
