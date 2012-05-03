class CustomersController < ApplicationController
  
  def index
    @title = "Welcome"
  end
  
  def show
    @customer = Customer.find_by_id(params[:id])
    @restaurant = @customer.restaurants[0]
    @title = "Your wait at " << @restaurant.name
  end
  
end