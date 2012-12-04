class AccountTransaction < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :from_account, :class => "Account", :foreign_key => "from_account_id"
  belongs_to :to_account, :class => "Account", :foreign_key => "to_account_id"

  def save_tranction(from_account_id, to_account_id, amount_hash = {})
  	amount_details = {:saving => amount_hash[:saving].to_f, :due => amount_hash[:due].to_f, :principle_debit => amount_hash[:principle_debit].to_f, :principle_credit => amount_hash[:principle_credit].to_f, :interest_credit => amount_hash[:interest_credit].to_f}
  	self.attributes = {:from_account_id => from_account_id, :to_account_id => to_account_id}.merge!(amount_details)
  	self.save
  end	

end
