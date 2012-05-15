class AddPicToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :pic, :string
  end
end
