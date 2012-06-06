class ApplicationController < ActionController::Base
  
  require 'net/http'
  
  #Protects only non-get requests
  protect_from_forgery
  
  helper_method :current_restaurant
  
  include AppointmentsHelper
  include PostsHelper
  include ApplicationHelper
  include TableTypesHelper
  
  require 'twilio-ruby'
  
  def signed_in
    redirect_to(root_url, :notice => "Please sign in!") unless current_restaurant.present?
  end
  
  def correct_restaurant
    post = Post.find_by_id(params[:id])
    redirect_to(main_url, :notice => "Cannot view others' posts!") unless current_restaurant.id == post.restaurant_id
  end

  private
  
    def current_restaurant
      @current_restaurant ||= Restaurant.find_by_id(session[:restaurant_id]) if session[:restaurant_id]
    end
    
end
