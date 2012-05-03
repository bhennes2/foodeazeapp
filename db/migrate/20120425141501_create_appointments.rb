class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :name
      t.integer :party
      t.integer :wait
      t.boolean :seated

      t.timestamps
    end
  end
end
