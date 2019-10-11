class AddIsVirtual < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :is_virtual, :boolean, default: false
  end
end
