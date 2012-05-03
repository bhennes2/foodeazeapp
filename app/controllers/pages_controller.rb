class PagesController < ApplicationController

  def index
    @title = "FoodEaze"
  end
  
  def main
    @title = current_restaurant.name
    @layout = current_restaurant.layout
  end
  
  def metrics
    @title = "Your metrics"
    @appointments = current_restaurant.appointments
    @parties = party_sizes(@appointments)
  end
  

  
end