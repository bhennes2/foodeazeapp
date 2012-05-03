class AddUidToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :twitter_id, :integer
  end
end
