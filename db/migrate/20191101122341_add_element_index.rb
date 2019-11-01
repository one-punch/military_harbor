class AddElementIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :exam_paper_elements, :proto_id
    add_index :exam_paper_elements, :proto_paper_id
  end
end
