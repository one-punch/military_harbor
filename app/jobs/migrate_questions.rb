class MigrateQuestions < ApplicationJob
  queue_as :default

  def perform
    log_file = File.open("#{Rails.root}/log/migrate_questions.log", 'a')
    @logger = Logger.new log_file

    @subjects = Subject.all
    ExamPaperElement.where("question IS NOT NULL").find_each do |element|
      ques = JSON.parse element[:question]
      subject = @subjects.find{|sub| sub.name == ques["subjectName"] }
      question = Question.where(proto_id: ques["queId"]).first_or_create(
        proto_id: ques["queId"],
        proto_parent_id: ques["parentId"],
        proto_root_id: ques["rootId"],
        subject_id: subject.id,
        grade_group_id: ques["gradeGroupId"],
        logic_ques_type_id: ques["logicQuesTypeId"],
        difficulty: ques["difficulty"],
        written_ques_type_id: ques["writtenQuesTypeId"],
        written_ques_type_name: ques["writtenQuesTypeName"],
        content: ques["content"],
        answer: ques["answer"],
        analysis: ques["analysis"],
        deleted: ques["deleted"],
        organization_list: ques["organizationList"],
        keyword: ques["keyword"],
        video_url: ques["videoUrl"],
        voice_text: ques["voiceText"],
        translated_text: ques["translatidText"],
        que_desc: ques["queDesc"],
        que_preview_url: ques["quePreviewUrl"],
        order_id: ques["orderId"],
        is_analysis: ques["isAnalysis"],
        answer_type: ques["answerType"],
        is_decidable: ques["isDecidable"],
        blank_answer: ques["blankAnswer"],
        bx_answer: ques["bxAnswer"],
        degree: ques["degree"],
        option_analysis_list: ques["optionAnalysisList"],
        option_difficulty_list: ques["optionDifficultyList"],
        answer_option_list: ques["answerOptionList"],
        question_source_list: ques["questionSourceList"],
        exam_option_list: ques["examOptionList"],
        option_exam_option_list: ques["optionExamOptionList"],
        que_source: ques["queSource"],
        duplicate_flag: ques["duplicateFlag"],
        deprecated: ques["deprecated"],
        is_have_analysis: ques["isHaveAnalysis"]
      )
      if question.new_record?
        @logger.error("element: #{element.id} fail, errors: #{question.errors.full_messages.join(';')}")
      else
        element.update_attributes(proto_question_id: question.proto_id)
      end
      # TODO miss childList
    end
  end

end