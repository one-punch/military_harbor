class AddParentIdInProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :parent_id, :integer, null: true
  end
end
