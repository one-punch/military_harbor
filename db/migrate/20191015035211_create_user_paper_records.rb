class CreateUserPaperRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :user_paper_records do |t|
      t.integer :user_id, null: false
      t.integer :paper_id, null: false
      t.date    :expired_at
      t.boolean :allow_download, default: false
      t.timestamps
    end
    add_index :user_paper_records, [:user_id, :paper_id], unique: true
  end
end
