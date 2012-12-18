class Group < ActiveRecord::Base
  
  attr_accessible :name

  has_one :account, :as => :accountable
  has_many :groups_users
  has_many :users, :through => :groups_users

  after_save :create_account

  def create_account
  	Account.make_account(self)
  end	

end
