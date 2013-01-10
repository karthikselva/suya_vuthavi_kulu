class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :dob
  # attr_accessible :title, :body
  belongs_to :role
  has_one :account, :as => :accountable
  has_one :groups_user

  after_save :create_account
  
  def create_account
    Account.make_account(self)
  end

  def full_name
    first_name + " " + last_name
  end  

  def group_name
    groups_user ? groups_user.group.name : ""
  end  

  def get_group
    groups_user ? groups_user.group : ""
  end 

  def monthly_decision_book(tran_date)
    atds = AccountTranDetail.where(["from_account_id = ? and to_account_id = ? and transaction_date = ? and (saving != 0 or due != 0 or other_amount != 0 or principle_credit != 0 or interest_credit != 0)",self.account.id, self.get_group.account.id, tran_date])
    ac = {"saving" => 0, "due" => 0, "principle_credit" => 0, "interest_credit" => 0, "other_amount" => 0}
    return atds.inject(ac){|acc,val|
      acc["saving"] = acc["saving"].to_f + val.saving.to_f
      acc["due"] = acc["due"].to_f + val.due.to_f
      acc["principle_credit"] = acc["principle_credit"].to_f + val.principle_credit.to_f
      acc["interest_credit"] = acc["interest_credit"].to_f + val.interest_credit.to_f
      acc["other_amount"] = acc["other_amount"].to_f + val.other_amount.to_f
      acc
    }
  end

end
