class GroupsController < ApplicationController

  def index
  	@groups = Group.order("name")
  end  

  def new
    @group = Group.new
  end

  def create
  	@group = Group.new(params[:group])
  	if @group.save
  	  flash[:notice] = "Group was saved"	
  	  redirect_to groups_path
  	else
  	  flash[:notice] = "Group was not saved"	
  	  render :action => :new
  	end 
  end

  def edit
  	@group = Group.find(params[:id])
  end

  def update
  	@group = Group.find(params[:id])
  	if @group.update_attributes(params[:group])
  	  flash[:notice] = "Group was saved"	
  	  redirect_to groups_path
  	else
  	  flash[:notice] = "Group was not saved"	
  	  render :action => :new
  	end
  end

  def destroy
  	@group = Group.find(params[:id])
  	@group.destroy
    redirect_to groups_path
  end	

end
