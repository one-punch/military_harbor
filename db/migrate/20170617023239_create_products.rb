class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string  :name
      t.string  :sku
      t.text    :description
      t.boolean :active, default: true
      t.decimal :price,             precision: 8, scale: 2, default: 0.0
      t.decimal :purchase_price,    precision: 8, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
