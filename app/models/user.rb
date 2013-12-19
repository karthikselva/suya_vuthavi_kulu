class User < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :dob
  has_one :account, :as => :accountable
  has_one :groups_user
  has_and_belongs_to_many :roles
  has_many :roles_user  

  after_create :create_account
  
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

  def role_names
    roles.collect(&:name)
  end  

end
