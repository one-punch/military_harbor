class Question < ApplicationRecord
  has_many    :exam_paper_elements,  primary_key: "proto_id", foreign_key: "proto_question_id"
  belongs_to  :parent, class_name: "Question", optional: true, primary_key: "proto_id", foreign_key: "proto_parent_id", optional: true
  belongs_to  :root, class_name: "Question", optional: true, primary_key: "proto_id", foreign_key: "proto_root_id", optional: true
  has_many    :childList, -> { order 'questions.number ASC' } ,class_name: "Question", primary_key: "proto_id", foreign_key: "proto_parent_id"

  serialize :answer, JSON
  serialize :analysis, JSON
  serialize :organization_list, JSON
  serialize :blank_answer, JSON
  serialize :bx_answer, JSON
  serialize :option_analysis_list, JSON
  serialize :option_difficulty_list, JSON
  serialize :answer_option_list, JSON
  serialize :question_source_list, JSON
  serialize :exam_option_list, JSON
  serialize :option_exam_option_list, JSON
  serialize :que_source, JSON

  # 只有一般的试卷可以使用
  def answer_options
    @_answer_options ||= answer_option_list.map do |answer_options|
      if answer_options.is_a?(Array)
        answer_options.map do |option|
          Hashie::Mash.new option
        end
      elsif answer_options.is_a?(Hash)
        [Hashie::Mash.new(answer_options)]
      end
    end if answer_option_list.present?
  end


  def option_analysises
    @_option_analysises ||= option_analysis_list.map do |options_analysis|
      Hashie::Mash.new options_analysis
    end if option_analysis_list.present?
  end


end
  # writtenquestypeId 在普通试卷中表示字面意思，年级组，在课程的试题里面表示试卷的分类组
