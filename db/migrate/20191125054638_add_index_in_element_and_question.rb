class AddIndexInElementAndQuestion < ActiveRecord::Migration[5.1]
  def change
    add_index :questions, :proto_id, unique: true
    add_index :questions, :proto_parent_id
    add_index :questions, :proto_root_id
    add_index :questions, :subject_id
    add_index :questions, :number

  end
end
