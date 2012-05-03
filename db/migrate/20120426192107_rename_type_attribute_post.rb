class RenameTypeAttributePost < ActiveRecord::Migration
  def up
    rename_column :posts, :type, :subject
  end

  def down
    rename_column :posts, :subject, :type
  end
end
