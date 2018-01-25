class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.decimal :price,             precision: 8, scale: 2, default: 0.0
      t.integer :quantity
      t.integer :product_id
      t.integer :order_id
    end
  end
end
