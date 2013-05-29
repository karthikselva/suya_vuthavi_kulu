class AccountTransactionsController < ApplicationController

  def show_transactions
    flash[:notice] = "Successfully Saved"
    
    @atd_credits = AccountTranDetail.where(:id => params[:atd_credit_id].split(",")) if !params[:atd_credit_id].blank?
    @atd_debits = AccountTranDetail.where(:id => params[:atd_debit_id].split(",")) if !params[:atd_debit_id].blank?
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
   credit_trans_arr = [] 
   debit_trans_arr = []
   for key in params[:account_tran_detail].keys
     user_account = User.find(params[:member][key][:id]).account 
     group_account = Group.find(params[:group][:id]).account	
   	 #inflow
   	 amount_hash = {:saving => params[:account_tran_detail][key][:saving].to_f, :due => params[:account_tran_detail][key][:due].to_f, :principle_credit => params[:account_tran_detail][key][:principle_credit].to_f, :interest_credit => params[:account_tran_detail][key][:interest_credit].to_f, :other_amount => params[:account_tran_detail][key][:other_amount].to_f}
     if amount_hash.values.any?{|v| v > 0 }
	     atd_credit = AccountTranDetail.new
	     atd_credit.save_tranction(user_account.id, group_account.id, params[:transaction_date].to_date, amount_hash)
       credit_trans_arr << atd_credit.id
	   end    

   	 #outflow
   	 if params[:account_tran_detail][key][:principle_debit].to_f > 0 
       atd_debit = AccountTranDetail.new
   	   atd_debit.save_tranction(group_account.id, user_account.id, params[:transaction_date].to_date, {:principle_debit => params[:account_tran_detail][key][:principle_debit]})
       debit_trans_arr << atd_debit.id
   	 end 
   end
   redirect_to show_transactions_account_transactions_path(:atd_credit_id => credit_trans_arr.join(","), :atd_debit_id => debit_trans_arr.join(","))
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
      @atd_credit.save_tranction(selected_group_account.id, group_account.id, params[:transaction_date].to_date, amount_hash)
    end    

    #outflow
    if params[:account_tran_detail][:principle_debit].to_f > 0 
      @atd_debit = AccountTranDetail.new
      @atd_debit.save_tranction(group_account.id, selected_group_account.id, params[:transaction_date].to_date, {:principle_debit => params[:account_tran_detail][:principle_debit]})
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
      @atd_credit.save_tranction(bank_account.id, group_account.id, params[:transaction_date].to_date, amount_hash)
    end    

    #outflow
    amount_hash = {:principle_debit => params[:account_tran_detail][:principle_debit].to_f}
    if amount_hash.values.any?{|v| v > 0 } #params[:account_tran_detail][:principle_debit].to_f > 0 
      @atd_debit = AccountTranDetail.new
      @atd_debit.save_tranction(group_account.id, bank_account.id, params[:transaction_date].to_date, amount_hash)
    end 
    redirect_to show_transactions_account_transactions_path(:atd_credit_id => @atd_credit ? @atd_credit.id : "", :atd_debit_id => @atd_debit ? @atd_debit.id : "")
  end

  def load_group_balances
    base_group = Group.find(params[:base_group_id])
    selected_group = Group.find(params[:selected_group_id])
    # result = {
    #   "principle_credit" => selected_group.outstanding_balance(base_group, params[:date].to_date),
    #   "interest_credit" => selected_group.get_balance_interest(base_group, params[:date].to_date)
    # }
    result = Group.balance_principal_and_interest(base_group, selected_group, params[:date].to_date)
    respond_to do |format|
      format.json{
        render :json => result.to_json,:layout => false
      } 
    end
  end

  def expenses
    @groups = Group.order("name")
  end 

  def save_expenses
    group = Group.find(params[:selected][:group_id])
    amount_hash = {:other_amount => params[:account_tran_detail][:other_amount].to_f}
    if amount_hash.values.any?{|v| v > 0 }
      @atd_credit = AccountTranDetail.new(:comments => params[:account_tran_detail][:comments])
      @atd_credit.save_tranction(group.account.id, EXPENSES_ACC_ID, params[:account_tran_detail][:transaction_date].to_date, amount_hash)
    end
    redirect_to show_transactions_account_transactions_path(:atd_credit_id => @atd_credit ? @atd_credit.id : "", :atd_debit_id => "")
  end 

  def update_balance
    
  end  

  def save_update_balance
    Group.update_final_balance(params[:balance][:update_date].to_date)
    Group.update_bank_final_balance(params[:balance][:update_date].to_date)
    redirect_to root_url
  end 
    
end	
