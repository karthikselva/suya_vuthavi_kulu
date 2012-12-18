class CustomDevise::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication, :only => [:new, :create]

  # # method for signup form
  def new
    super
  end

  # # method to create user
  def create
    super
    # build_resource
    # verified = verify_recaptcha(:model => resource)
    # if resource.valid? && verified
    #   User.transaction do |transaction|
    #     resource.save
    #     group = !resource.join_group.blank? ? Group.find(@user.join_group) : nil
    #     @user_group = UserGroup.find_or_initialize_by_user_id_group_id(resource.id,group.id) if group
    #     user_group.save if @user_group && @user_group.new_record?
    #   end  

    #   if resource.active_for_authentication?
    #     set_flash_message :notice, :signed_up if is_navigational_format?
    #     sign_in(resource_name, resource)
    #     respond_with resource, :location => after_sign_up_path_for(resource)
    #   else
    #     set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
    #     expire_session_data_after_sign_in!
    #     respond_with resource, :location => after_inactive_sign_up_path_for(resource)
    #   end
    # else
    #   resource.errors.add("general", "Captcha code is incorrect") if !verified
    #   clean_up_passwords resource
    #   respond_with resource
    # end
  end  

  def update
    super
  end

  protected

  def after_sign_up_path_for(resource)
    root_url
  end

end