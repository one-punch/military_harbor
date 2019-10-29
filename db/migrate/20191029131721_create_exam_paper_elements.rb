class CreateExamPaperElements < ActiveRecord::Migration[5.1]
  def change
    create_table :exam_paper_elements do |t|
      t.string     :proto_id, null: false
      t.string     :proto_paper_id, null: false
      t.string     :content
      t.integer    :contentType
      t.string     :axis
      t.string     :number
      t.string     :remark
      t.boolean    :deleted
      t.string     :blank
      t.string     :queTypeName
      t.text       :hideMainIdList
      t.text       :hideQueIdList
      t.mediumtext :question
      t.string     :contentTypeCode

      t.timestamps
    end
  end
end
