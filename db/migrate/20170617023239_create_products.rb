class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :sku
      t.text    :description
      t.boolean :active, default: true
      t.decimal :price,             precision: 8, scale: 2, default: 0.0
      t.decimal :purchase_price,    precision: 8, scale: 2, default: 0.0
      t.decimal :weight,            precision: 8, scale: 2, default: 0.0
      t.integer :category_id
      t.integer :parent_id
      t.integer :product_detail_id
      t.timestamps
    end
  end
end
