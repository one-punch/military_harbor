class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :proto_id, null: false
      t.string :proto_parent_id
      t.string :proto_root_id
      t.integer :subject_id, null: false, default: 0
      t.integer :grade_group_id, null: false, default: 1
      t.integer :logic_ques_type_id
      t.integer :difficulty, default: 0
      t.string :written_ques_type_id
      t.string :written_ques_type_name
      t.text   :content
      t.text   :answer
      t.text   :analysis
      t.boolean :deleted, null: false, default: false
      t.text   :organization_list
      t.string :keyword
      t.string :video_url
      t.string :voice_text
      t.string :translated_text
      t.string :que_desc
      t.string :que_preview_url
      t.string :order_id
      t.boolean :is_analysis, default: false
      t.integer :answer_type
      t.boolean :is_decidable, default: true
      t.text  :blank_answer
      t.text  :bx_answer
      t.integer :degree
      t.text    :option_analysis_list
      t.text    :option_difficulty_list
      t.text    :answer_option_list
      t.text    :question_source_list
      t.text    :exam_option_list
      t.text    :option_exam_option_list
      t.text    :que_source
      t.boolean :duplicate_flag, default: false
      t.boolean :deprecated, default: false
      t.boolean :is_have_analysis, default: false
      t.timestamps
    end
  end
end
