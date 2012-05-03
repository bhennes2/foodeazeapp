class AddCustomerIdToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :customer_id, :integer
  end
end
