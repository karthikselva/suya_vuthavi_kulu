class BanksController < ApplicationController
 
  def index
  	@banks = Bank.order("bank_name")
  end  

  def new
    @bank = Bank.new
  end

  def create
  	@bank = Bank.new(params[:bank])
  	if @bank.save
  	  flash[:notice] = "Bank was saved"	
  	  redirect_to banks_path
  	else
  	  flash[:notice] = "Bank was not saved"	
  	  render :action => :new
  	end 
  end

  def edit
  	@bank = Bank.find(params[:id])
  end

  def update
  	@bank = Bank.find(params[:id])
  	if @bank.update_attributes(params[:bank])
  	  flash[:notice] = "Bank was saved"	
  	  redirect_to banks_path
  	else
  	  flash[:notice] = "Bank was not saved"	
  	  render :action => :new
  	end
  end

  def destroy
  	@bank = Bank.find(params[:id])
  	@bank.destroy
  	redirect_to banks_path
  end

end
