class CreateVirtualProductActualProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :virtual_product_actual_products do |t|
      t.integer :virtual_product_id, null: false
      t.integer :actual_product_id, null: false
      t.timestamps
    end
    add_index :virtual_product_actual_products, [:virtual_product_id, :actual_product_id], unique: true, name: "index_virtual_actual_products_on_virtual_and_actual_id"
  end
end
