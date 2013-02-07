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
    self.account.monthly_decision_book(tran_date, self.get_group.account.id)
  end

  def monthly_decision_book_debit(tran_date)
    self.account.monthly_decision_book_debit(tran_date, self.get_group.account.id)
  end

  def last_month_outstanding_Principal(date)
    self.account.last_month_outstanding_Principal(date, self.get_group.account.id)
  end  

  def get_current_month_interest(date)
    pa = last_month_outstanding_Principal(date)
    get_interest(pa)
  end

  def get_balance_interest(date)
    intr = get_current_month_interest(date)
    intr - monthly_decision_book(date)["interest_credit"].to_f
  end

  def get_balance_saving(date)
    self.get_group.saving_amount - monthly_decision_book(date)["saving"]
  end   
  
  def get_balance_due(date)
    self.get_group.due_amount - monthly_decision_book(date)["due"]
  end

end
