class ChangeContentToText < ActiveRecord::Migration[5.1]
  def change
    change_column :exam_paper_elements, :content, :text
  end
end
