class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :type
      t.text :content
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
