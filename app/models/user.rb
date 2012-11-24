class User < ActiveRecord::Base
  attr_accessible :username
  has_one :account , :as => :accountable
  belongs_to :group

  # Accessor: Get list of all transactions

  def transactions
    account_obj = self.account
    if account_obj.present?
      return account_obj.account_transactions
    else
      return nil
    end
  end

  # Use this function for user paying a due_amt 
  # @params: 
  #   * due_amt : Monthly amount mandatory to be paid to group 
  #   * principal_amt : If money is borrowed previously pay the principal in parts 
  #   * interest : Additional Interest for the principal_amt

  def pay_due(due_amt,principal_amt=0,interest=0)
    if due_amt > 0
      AccountTransaction.create(:from_account_id => self.account.id ,
          :to_account_id => self.group_id ,
          :principle_credit_amount => principal_amt ,
          :principle_interest_amount => interest)
    else 
      raise "Due amount should be greater than one "
    end
end

end
