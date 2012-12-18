class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  before_filter :authenticate_user!

  layout :determine_layout

  def determine_layout
  	"application"
  end	
end
