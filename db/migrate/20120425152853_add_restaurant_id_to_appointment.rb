class AddRestaurantIdToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :restaurant_id, :integer
  end
end
