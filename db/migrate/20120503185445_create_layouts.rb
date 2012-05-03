class CreateLayouts < ActiveRecord::Migration
  def change
    create_table :layouts do |t|
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
