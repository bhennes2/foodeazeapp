class AddPhonetoAppointment < ActiveRecord::Migration
  def up
    add_column :appointments, :phone, :string
  end

  def down
    remove_column :appointments, :phone, :string
  end
end
