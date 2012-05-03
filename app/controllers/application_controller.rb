class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_restaurant
  
  include AppointmentsHelper
  include PostsHelper
  include ApplicationHelper
  
  require 'twilio-ruby'

  private
  
    def current_restaurant
      @current_restaurant ||= Restaurant.find(session[:restaurant_id]) if session[:restaurant_id]
    end
  
end
