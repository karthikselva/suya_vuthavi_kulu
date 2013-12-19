class UsersController < ApplicationController

  def index
  end  

  def list

    # raise @users[0].inspect
    @groups = Group.order("name")
    @users = User.order("first_name")
  end	

  def edit
  	@user = User.find(params[:id])
    @groups = Group.order("name")
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(params[:user])
      @user.account.update_attributes(:name => @user.full_name)
      if @user.groups_user
        @user.groups_user.update_attributes(:group_id => params[:selected][:group_id])
      else  
        groups_user = GroupsUser.new(:user_id => @user.id, :group_id => params[:selected][:group_id])
        groups_user.save
      end  
  	  flash[:notice] = "User was saved"	
  	  redirect_to list_users_path
  	else
  	  flash[:notice] = "User was not saved"	
  	  render :action => :new
  	end
  end

  def destroy
  	@user = User.find(params[:id])
  	@user.destroy
    redirect_to users_path
  end
  def search
    @users = User.joins(:groups_user).select("users.*")
    @users = @users.where(["first_name like ? or last_name like ?", "%#{params[:search][:first_name]}%", "%#{params[:search][:first_name]}%"]) if !params[:search][:first_name].blank?
    @users = @users.where(:groups_users => {:group_id => params[:search][:group_id]}) if !params[:search][:group_id].blank?
    #   flash[:notice] = "SEARCH RESULT NOT FOUND" 
    #   redirect_to list_users_path
    # end
  end  
end

