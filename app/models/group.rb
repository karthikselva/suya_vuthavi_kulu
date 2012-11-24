class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :account , :as => :commentable
  has_many :users 
 
  # Used when group sanction some money to Member
  # @params:
  #  * user_id : Sanctioned Member
  #  * Amount : Money sanctioned 

  def sanction_amount(user_id,amount)
    user = User.find_by_id(user_id)
    if user.present?
      user.total_credit = user.total_credit + amount
      user.save!
      AccountTransaction.create( :from_account_id => :self.account.id ,
          :to_account_id => user.account.id ,
          :principle_debit_amount => amount )
    else 
      raise " No Such User with id #{user_id} "
    end
  end

  # Make an User as admin for Particular Group 
  # @params: 
  #  * user_id : Valid Member in that group 

  def make_as_admin(user_id)
    GroupAdmin.create( :group_id => self.id ,
        :user_id => user_id )
  end

  # Used when some other group sanctions money this group
  # @params:
  #  * group_id : Other group which allocates the money
  #  * Amount : Money sanctioned 

  def borrow_from_group(group_id,amount)
    group = Group.find_by_id(group_id)
    if group.present?
      group.total_amount = group.total_amount + amount
      group.save!
      AccountTransaction.create( :from_account_id => group.account.id ,
          :to_account_id => self.account.id ,
          :principle_debit_amount => amount )
    else 
      raise " No Such group with id #{group_id} "
    end
  end
end
