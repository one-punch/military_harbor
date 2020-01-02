class AddContentInPaper < ActiveRecord::Migration[5.1]
  def change
    add_column :papers, :content, :text
  end
end
