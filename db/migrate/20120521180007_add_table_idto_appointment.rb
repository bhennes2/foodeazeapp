class AddTableIdtoAppointment < ActiveRecord::Migration
  def up
    add_column :appointments, :table_id, :integer
  end

  def down
    remove_column :appointments, :table_id
  end
end
