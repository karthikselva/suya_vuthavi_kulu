class User < ActiveRecord::Base
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

end
