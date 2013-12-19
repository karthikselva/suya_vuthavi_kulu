class ReportsController < ApplicationController
  
  def loan_details
  	@groups =Group.order("name")
  end	

  def load_loan_details
  	@group = Group.find(params[:group_id])
  	@members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
    @groups =Group.where(["id != ?",params[:group_id]]).order("name")
  	render :layout => false
  end

  def monthly_loan_details
  	@groups =Group.order("name")
  end	

  def load_monthly_loan_details
  	@group = Group.find(params[:group_id])
  	@members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
  	render :layout => false
  end

  def grand_details
    @groups = Group.order("name")
  end 

  def load_grand_details
    @group = Group.find(params[:group_id])
    @members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
    render :layout => false
  end

  # def group_loan_details
  #   @groups = Group.order("name")
  # end 

  # def load_group_loan_details
  #   @group = Group.find(params[:group_id])
  #   @members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
  #   render :layout => false
  # end

  def transactions

  end  

  def transaction_details
    from_date = params[:from_date].to_date.beginning_of_month
    to_date = params[:to_date].to_date.end_of_month
    @account = User.find(params[:user_id]).account
    @acc_tran_details = AccountTranDetail.where(["(from_account_id = ? or to_account_id = ?) and transaction_date >= ? and transaction_date <= ?", @account.id, @account.id, from_date.to_date, to_date.to_date]).order("transaction_date")
    render :layout => false
  end

end	