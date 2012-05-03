class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :phone
      t.string :name
      t.string :email
      t.integer :zipcode

      t.timestamps
    end
  end
end
