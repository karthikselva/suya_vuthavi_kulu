class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  before_filter :authenticate_user!
  # before_filter :autherise

  layout :determine_layout

  def determine_layout
  	"application_kumar" #{}"application"
  end	

  def after_sign_in_path_for(resource)
    root_url
  end  

  def autherise
  	if user_signed_in?
      # if current_user.role_names.include?("Normal")
      # 	{"action"=>"list", "controller"=>"users"}
      #   ["users" => {}, "groups" => , "banks" => {}, "reports" => {}].include?(params[:controller]) && ["list"]
      # end	
  	end	
  end	

end
