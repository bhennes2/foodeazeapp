class CreateTableTypes < ActiveRecord::Migration
  def change
    create_table :table_types do |t|
      t.integer :layout_id
      t.integer :size
      t.integer :quantity
      t.float :turnover

      t.timestamps
    end
  end
end
