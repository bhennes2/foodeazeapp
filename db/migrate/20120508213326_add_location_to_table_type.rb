class AddLocationToTableType < ActiveRecord::Migration
  def change
    add_column :table_types, :location, :string
  end
end
