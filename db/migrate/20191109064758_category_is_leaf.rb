class CategoryIsLeaf < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :is_leaf, :boolean
    add_index :categories, :is_leaf
  end
end
