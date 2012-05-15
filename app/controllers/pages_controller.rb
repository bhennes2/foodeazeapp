class PagesController < ApplicationController

  before_filter :signed_in, :only => [:main, :metrics]

  def index
    @title = "FoodEaze"
  end
  
  def main
    @title = current_restaurant.name
    @layout = current_restaurant.layout
  end
  
  def metrics
    @title = "Your metrics"
    @appointments = current_restaurant.appointments.order("created_at ASC")
    @parties = party_sizes(@appointments)
  end
  
  def profile
    
  end
  

  
end