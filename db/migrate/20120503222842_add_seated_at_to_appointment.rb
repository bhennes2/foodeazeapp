class AddSeatedAtToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :seated_at, :datetime
  end
end
