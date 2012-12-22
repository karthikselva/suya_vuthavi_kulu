class CustomDevise::PasswordsController < Devise::PasswordsController
  # prepend_before_filter :require_no_authentication, :only => [:new, :create]

  # def new
  #   super
  # end

  # # method for reset password.
  # # This method will send email to user to set a new password.
  # def create
  #   self.resource = resource_class.send_reset_password_instructions(resource_params)

  #   if successfully_sent?(resource)
  #     respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
  #   else
  #     respond_with(resource)
  #   end
  # end

  # # method for change password.
  # # This method will update with new password.  
  # def update
  #   @user = current_user
  #   if params[:user][:current_password].blank? || params[:user][:password].blank? || params[:user][:password_confirmation].blank?
  #     redirect_to :controller => "/preferences", :action => "personal_info", :msg => "Password fields can't be blank" 
  #   else   
  #     if @user.update_with_password(params[:user])
  #       sign_in(@user, :bypass => true)
  #       # redirect_to root_path, :notice => "Your Password has been updated!"
  #       after_update_path_for(resource)
  #     else
  #       redirect_to :controller => "/preferences", :action => "personal_info", :msg => @user.errors.full_messages.join("; ")
  #     end
  #   end  
  # end

  # protected

  # # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   signup_path
  # end

  # # The path used after update password
  # def after_update_path_for(resource_name)
  #   redirect_to :controller => "/aggregates", :action => "index", :msg => "Your Password has been updated!"
  # end


end