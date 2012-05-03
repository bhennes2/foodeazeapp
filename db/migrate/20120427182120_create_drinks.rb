class CreateDrinks < ActiveRecord::Migration
  def change
    create_table :drinks do |t|
      t.text :content
      t.integer :post_id
      
      t.timestamps
    end
  end
end
