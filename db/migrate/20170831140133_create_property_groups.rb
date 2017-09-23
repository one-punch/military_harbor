class CreatePropertyGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :property_groups do |t|
      t.integer :product_id, null: false
      t.string  :name, null: false
      t.integer :position, default: 0
      t.timestamps
    end
  end
end
