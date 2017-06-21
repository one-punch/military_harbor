class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.integer  :source_id,   null: false
      t.string   :source_type, null: false
      t.string   :file, null: false
      t.string   :file_name
      t.integer  :file_size
      t.string   :file_type
      t.string   :role
      t.timestamps
    end
  end
end
