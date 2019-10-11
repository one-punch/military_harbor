class AddProductIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :products, :is_virtual
    add_index :products, :parent_id
    add_index :products, :category_id
    add_index :products, :active
  end
end
