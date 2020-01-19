class RemovePaperContent < ActiveRecord::Migration[5.1]
  def change
    remove_column :papers, :content
  end
end
