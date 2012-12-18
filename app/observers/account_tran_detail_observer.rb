class AccountTranDetailObserver < ActiveRecord::Observer
  
  observe :account_tran_detail

  def after_save_tranction(*args)
    self_obj = args[0]
    from_account = self_obj.from_account
    to_account = self_obj.to_account

    if [User,Group].include?(from_account.accountable.class) && [User,Group].include?(to_account.accountable.class)
      if self_obj.principle_debit.to_f > 0
      	outs_balance = to_account.outstanding_balance.to_f
        outs_balance = outs_balance + self_obj.principle_debit.to_f
        to_account.update_attributes(:outstanding_balance => outs_balance)
        self_obj.update_attributes(:to_outs_balance => outs_balance)
      end
      if self_obj.principle_credit.to_f > 0
      	outs_balance = from_account.outstanding_balance.to_f
        outs_balance = outs_balance - self_obj.principle_credit.to_f 
        from_account.update_attributes(:outstanding_balance => outs_balance)
        self_obj.update_attributes(:from_outs_balance => outs_balance)
      end  
    end
  end

end