class SectionsService

  def initialize(paper, knowledge_json)
    @paper = paper
    @material = @paper.material
    @course = @material.course
    @subject = @course.subject
    @knowledge_json = knowledge_json
  end

  def exec
    @knowledge_json[:sections].each_with_index do |section, idx|
      element = ExamPaperElement.where(proto_id: section[:id]).first_or_initialize(
        proto_paper_id: @paper.proto_id,
        contentType: question_type(section[:type]), # QUESTION 固定5
        number: idx,
        contentTypeCode: section[:type].upcase,
        proto_question_id: section[:id],
      )
      if element.save
        ques = exchange(section, parent_id: nil)
        question_service = QuestionService.new(element, @subject, ques)
        question_service.build_question(ques,
          parent_id: nil,
          root_id: nil,
          number: ques[:number]
        )
        exec_sub_question(element, section[:questions], parent_id: section[:id], root_id: section[:id]) if section[:questions]
      else

      end
    end
  end

  def question_type(proto_type)
    _case = proto_type.downcase
    if _case.include?("title")
      1
    elsif _case.include?("description")
      3
    elsif _case.include?("question")
      5
    else
      0
    end
  end

  def exec_sub_question(element, questions_json, parent_id: nil, root_id: nil)
    questions_json.each_with_index do |q, idx|
      ques = exchange(q, parent_id: parent_id)
      question_service = QuestionService.new(element, @subject, ques)
      question_service.build_question(ques,
        parent_id: parent_id,
        root_id: root_id,
        number: idx
      )
      exec_sub_question(element, q[:questions], parent_id: q[:id], root_id: root_id) if q[:questions]
    end
  end

  def exchange(ques, parent_id: nil)
    {
      "queId" => ques[:id],
      "content" => ques[:content],
      "answer" => ques[:answer],
      "analysis" => ques[:explanation],
      "writtenQuestypeName" =>  ques[:type],
      "number" => ques[:order],
      "parentId" => parent_id,
      "gradeGroupId" => @course.grade_group_id
    }
  end

end