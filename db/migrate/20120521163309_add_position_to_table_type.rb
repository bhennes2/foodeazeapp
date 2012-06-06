class AddPositionToTableType < ActiveRecord::Migration
  def up
    add_column :table_types, :position, :text
  end
  
  def down
    remove_column :table_types, :position
  end
end
