class TableTypeController < ApplicationController
  
  before_filter :signed_in
  
  def index
    @title = "Set up the layout for your restaurant"
    
    if current_restaurant.has_layout?
      @layout = Layout.find_by_restaurant_id(current_restaurant.id)
    else
      @layout = Layout.create(:restaurant_id => current_restaurant.id)
    end
    
    @table_type = TableType.new
    @table_types = current_restaurant.layout.table_types

  end
  
  def create
    @table_type = TableType.create(params[:table_type])
    
    redirect_to layout_url
  end
  
  def destroy
    @table_type = TableType.find_by_id(params[:id])
    @table_type.destroy
    
    redirect_to layout_url
  end
  
end