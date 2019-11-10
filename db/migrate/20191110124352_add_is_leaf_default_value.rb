class AddIsLeafDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column :categories, :is_leaf, :boolean, default: false
  end
end
