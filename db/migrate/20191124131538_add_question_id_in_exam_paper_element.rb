class AddQuestionIdInExamPaperElement < ActiveRecord::Migration[5.1]
  def change
    add_column :exam_paper_elements, :proto_question_id, :string
    add_index  :exam_paper_elements, :proto_question_id
  end
end
