class AddIndexToAppointmentName < ActiveRecord::Migration
  def change
    add_index :appointments, :name
  end
end
