class QuestionService

  attr_accessor :message, :subject, :ques, :element

  def initialize(element, subject, ques_json)
    @element = element
    @subject = subject
    @ques = ques_json
  end

  def exec
    if question.new_record?
      @message = "question: #{question.proto_id} fail, errors: #{question.errors.full_messages.join(';')}"
    else
      element.update_attributes(proto_question_id: question.proto_id)
      build_children(@ques["childList"], parent_id: question.proto_id, root_id: question.proto_id)
    end
    self
  end

  def success?
    @message.blank?
  end

  def question
    @_question ||= build_question(ques, parent_id: ques["parentId"], root_id: ques["rootId"])
  end

  def build_question(ques, parent_id: nil, root_id: nil, number: 0)
    Question.where(proto_id: ques["queId"]).first_or_create(
        proto_id: ques["queId"],
        proto_parent_id: [0, "0"].include?(parent_id) ? nil : parent_id ,
        proto_root_id: [0, "0"].include?(root_id) ? nil : root_id,
        subject_id: subject.id,
        grade_group_id: ques["gradeGroupId"],
        logic_ques_type_id: ques["logicQuesTypeId"],
        difficulty: ques["difficulty"],
        written_ques_type_id: ques["writtenQuesTypeId"],
        written_ques_type_name: ques["writtenQuesTypeName"],
        content: ques["content"],
        answer: ques["answer"],
        analysis: ques["analysis"],
        deleted: ques["deleted"] || false,
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
        is_have_analysis: ques["isHaveAnalysis"],
        number: number,
      )
  end

  def build_children(childList, parent_id: nil, root_id: nil)
    children = []
    childList.each_with_index do |child_json, idx|
      child = build_question(child_json, parent_id: parent_id, root_id: root_id, number: idx)
      if child.errors.present?
        @message = "question child: #{child.proto_id} fail, errors: #{child.errors.full_messages.join(';')}"
        return
      else
        children << child
      end
    end if childList.present?
    children
  end

end