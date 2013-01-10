class AccountTransactionsController < ApplicationController

  def show_transactions
    flash[:notice] = "Successfully Saved"
    
    @atd_credit = AccountTranDetail.find(params[:atd_credit_id]) if !params[:atd_credit_id].blank?
    @atd_debit = AccountTranDetail.find(params[:atd_debit_id]) if !params[:atd_debit_id].blank?
  end  

  def member_transaction
    @groups =Group.order("name")
  end	

  def load_members
  	@group = Group.find(params[:group_id])
  	@members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
  	render :layout => false
  end

  # status = Transaction::GuardedBlock.execute do |g|
  #   g.b { @group.image.save }
  # end

  def save_member_transaction
   for key in params[:account_tran_detail].keys
     user_account = User.find(params[:member][key][:id]).account 
     group_account = Group.find(params[:group][:id]).account	
   	 #inflow
   	 amount_hash = {:saving => params[:account_tran_detail][key][:saving].to_f, :due => params[:account_tran_detail][key][:due].to_f, :principle_credit => params[:account_tran_detail][key][:principle_credit].to_f, :interest_credit => params[:account_tran_detail][key][:interest_credit].to_f, :other_amount => params[:account_tran_detail][key][:other_amount].to_f}
     if amount_hash.values.any?{|v| v > 0 }
	     @atd_credit = AccountTranDetail.new
	     @atd_credit.save_tranction(user_account.id, group_account.id, amount_hash)
	   end    

   	 #outflow
   	 if params[:account_tran_detail][key][:principle_debit].to_f > 0 
       @atd_debit = AccountTranDetail.new
   	   @atd_debit.save_tranction(group_account.id, user_account.id, {:principle_debit => params[:account_tran_detail][key][:principle_debit]})
   	 end 
   end
   redirect_to show_transactions_account_transactions_path(:atd_credit_id => @atd_credit ? @atd_credit.id : "", :atd_debit_id => @atd_debit ? @atd_debit.id : "")
  end	

  def group_transaction
    @groups =Group.order("name")
  end

  def load_groups
    @groups = Group.where("id != #{params[:group_id]}").order("name")
    render :layout => false
  end

  def save_group_transaction
    group_account = Group.find(params[:group][:id]).account 
    selected_group_account = Group.find(params[:selected][:group_id]).account  
    #inflow
    amount_hash = {:principle_credit => params[:account_tran_detail][:principle_credit].to_f, :interest_credit => params[:account_tran_detail][:interest_credit].to_f, :other_amount => params[:account_tran_detail][:other_amount].to_f}
    if amount_hash.values.any?{|v| v > 0 }
      @atd_credit = AccountTranDetail.new
      @atd_credit.save_tranction(selected_group_account.id, group_account.id, amount_hash)
    end    

    #outflow
    if params[:account_tran_detail][:principle_debit].to_f > 0 
      @atd_debit = AccountTranDetail.new
      @atd_debit.save_tranction(group_account.id, selected_group_account.id, {:principle_debit => params[:account_tran_detail][:principle_debit]})
    end 
    redirect_to show_transactions_account_transactions_path(:atd_credit_id => @atd_credit ? @atd_credit.id : "", :atd_debit_id => @atd_debit ? @atd_debit.id : "")
  end 

  def bank_transaction
    @groups = Group.order("name")
  end

  def load_banks
    @banks = Bank.order("account_number")
    render :layout => false
  end

  def save_bank_transaction
    group_account = Group.find(params[:group][:id]).account 
    bank_account = Bank.find(params[:bank][:id]).account  
    #inflow
    amount_hash = {:principle_credit => params[:account_tran_detail][:principle_credit].to_f, :other_amount => params[:account_tran_detail][:other_amount].to_f}
    if amount_hash.values.any?{|v| v > 0 }
      @atd_credit = AccountTranDetail.new
      @atd_credit.save_tranction(bank_account.id, group_account.id, amount_hash)
    end    

    #outflow
    if params[:account_tran_detail][:principle_debit].to_f > 0 
      @atd_debit = AccountTranDetail.new
      @atd_debit.save_tranction(group_account.id, bank_account.id, {:principle_debit => params[:account_tran_detail][:principle_debit]})
    end 
    redirect_to show_transactions_account_transactions_path(:atd_credit_id => @atd_credit ? @atd_credit.id : "", :atd_debit_id => @atd_debit ? @atd_debit.id : "")
  end
    
end	