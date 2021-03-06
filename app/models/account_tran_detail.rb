class AccountTranDetail < ActiveRecord::Base
  attr_accessible :comments, :from_account_id, :to_account_id, :saving, :due, :principle_credit, :interest_credit, :principle_debit, :other_amount, :from_outs_balance, :to_outs_balance, :transaction_date

  belongs_to :user
  belongs_to :from_account, :class_name => "Account", :foreign_key => "from_account_id"
  belongs_to :to_account, :class_name => "Account", :foreign_key => "to_account_id"

  define_model_callbacks :save_tranction  

  def save_tranction(from_account_id, to_account_id, tran_date=Date.today, amount_hash = {})
  	amount_details = {:saving => amount_hash[:saving].to_f, :due => amount_hash[:due].to_f, :principle_debit => amount_hash[:principle_debit].to_f, :principle_credit => amount_hash[:principle_credit].to_f, :interest_credit => amount_hash[:interest_credit].to_f, :other_amount => amount_hash[:other_amount].to_f}
  	self.attributes = {:from_account_id => from_account_id, :to_account_id => to_account_id, :transaction_date => tran_date}.merge!(amount_details)
  	status = self.save

  	run_callbacks(:save_tranction){ notify_observers :after_save_tranction }
    status
  end	

end
