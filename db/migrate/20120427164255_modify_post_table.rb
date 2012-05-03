class ModifyPostTable < ActiveRecord::Migration
  def up
    remove_column :posts, :subject
    remove_column :posts, :content
    add_column :posts, :food_id, :integer    
    add_column :posts, :drink_id, :integer
    add_column :posts, :deal_id, :integer    
    add_column :posts, :general_id, :integer
  end

  def down
    remove_column :posts, :subject, :string
    remove_column :posts, :content, :text
    remove_column :posts, :food_id    
    remove_column :posts, :drink_id
    remove_column :posts, :deal_id
    remove_column :posts, :general_id
  end
end
