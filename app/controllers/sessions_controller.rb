class SessionsController < ApplicationController
  
  def create
     auth = request.env["omniauth.auth"]
     if Restaurant.where(:twitter_id => auth["uid"]) == []
       restaurant = Restaurant.create_with_omniauth(auth) 
    else
      restaurant = Restaurant.find_by_twitter_id(auth["uid"])
    end
    
     session[:restaurant_id] = restaurant.id
     redirect_to '/main'
   end
   
   def destroy
     session[:restaurant_id] = nil
     redirect_to root_url
   end
   
end