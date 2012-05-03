class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.text :content
      t.integer :post_id

      t.timestamps
    end
  end
end
