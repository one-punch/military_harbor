class AddParentIdInMaterials < ActiveRecord::Migration[5.1]
  def change
    add_column :materials, :proto_parent_id, :string, null: true
  end
end
