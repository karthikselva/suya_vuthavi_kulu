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

    if from_account.accountable.class == Group && to_account.accountable.class == Group
      account_ids = [from_account.id, to_account.id]
      gtd = GroupTransTrack.new(:from_account_id => from_account.id, :to_account_id => to_account.id, :transaction_date => self_obj.transaction_date)
      old_gtd = GroupTransTrack.where(["from_account_id in(?) and to_account_id in(?)", account_ids, account_ids]).order("id desc").first
      bal_amount = old_gtd ? [[old_gtd.from_account_id, old_gtd.from_to_outs_balance],[old_gtd.to_account_id, old_gtd.to_from_outs_balance]] : [[self_obj.from_account_id, 0],[self_obj.to_account_id, 0]]
      if self_obj.principle_debit.to_f > 0
        gtd.from_to_outs_balance = bal_amount.assoc(self_obj.from_account_id)[1] - self_obj.principle_debit.to_f
        gtd.to_from_outs_balance = bal_amount.assoc(self_obj.to_account_id)[1] + self_obj.principle_debit.to_f
      end  
      if self_obj.principle_credit.to_f > 0
        gtd.from_to_outs_balance = bal_amount.assoc(self_obj.from_account_id)[1] - self_obj.principle_credit.to_f
        gtd.to_from_outs_balance = bal_amount.assoc(self_obj.to_account_id)[1] + self_obj.principle_credit.to_f
      end
      gtd.save  
    end  

  end

end