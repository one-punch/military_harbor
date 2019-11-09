class AddIndexIsLeadCategory < ActiveRecord::Migration[5.1]
  def change
    add_index :categories, :ancestry_depth
    add_index :categories, :active
  end
end
