class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :country
      t.string :province
      t.string :city
      t.string :street
      t.string :zip
      t.integer :pay
      t.string :pay_number
      t.integer :status
      t.integer :shipper_id
      t.string :shipping_number
      t.text :description

      t.integer :user_id
      t.timestamps
    end
  end
end
