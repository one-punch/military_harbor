class AddPaperIdInProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :paper_id, :integer
    add_index :products, :paper_id
  end
end
