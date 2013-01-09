class ReportsController < ApplicationController
  
  def loan_details
  	@groups =Group.order("name")
  end	

  def load_loan_details
  	@group = Group.find(params[:group_id])
  	@members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
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
    @groups =Group.order("name")
  end 

  def load_grand_details
    @group = Group.find(params[:group_id])
    @members = @group.users.sort{|a,b| a.full_name <=> b.full_name }
    render :layout => false
  end

end	