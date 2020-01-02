class AddParentIdInCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :proto_parent_id, :string, null: true
  end
end
