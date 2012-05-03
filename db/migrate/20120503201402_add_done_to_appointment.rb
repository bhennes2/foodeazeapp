class AddDoneToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :done, :boolean
  end
end
