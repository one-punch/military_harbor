class ExamPaperElement < ApplicationRecord
  belongs_to :paper, primary_key: "proto_id", foreign_key: "proto_paper_id", optional: true

  belongs_to  :question, primary_key: "proto_id", foreign_key: "proto_question_id", optional: true

  serialize :hideMainIdList, JSON
  serialize :hideQueIdList, JSON
  # serialize :question, JSON
  serialize :attrs, JSON

  delegate :content, :answer_options, :answer, :childList, :analysis, to: :question_man, prefix: true, allow_nil: true
  # delegate :name, :student_version, :teacher_version, to: :paper, prefix: true, allow_nil: true


  def is_title?
    contentTypeCode == "FIRST_TITLE"
  end

  def is_section?
    contentTypeCode == "PARAGRAPH"
  end

  def is_question?
    contentTypeCode == "QUESTION"
  end

  def question_man
    question
  end


end
