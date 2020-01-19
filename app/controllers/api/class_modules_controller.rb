class Api::ClassModulesController < Api::ApplicationController

  def create
    case params[:code]
    when "course"
      course
    when "material"
      material
    when "paper"
      if data_params[:type] == "knoIns"
        kno_ins
      elsif data_params[:type] == "queSet"
        que_set
      end
    end
  end

  def course
    grade_id = \
      case data_params[:gradeGroupName]
      when "小学"
        6
      when "初中"
        9
      when "高中"
        12
      end
    grade = Grade.find grade_id
    subject = Subject.where(name: data_params[:subjectName]).take
    if grade.blank? || subject.blank?
      return render(:json => {code: 1, message: "grade and subject not found"}.to_json, :callback => params['callback'])
    end

    course = Course.where(proto_id: data_params[:id]).first_or_initialize(
        name: data_params[:name],
        subject_id: subject.id,
        grade_group_id: grade.group_id,
        type_name: "课程",
        grade_id: grade.id)
    course.save if course.new_record?
    data_params[:attrs].each do |att|
      Course.where(proto_id: att[:id]).first_or_create(
        name: att[:name],
        subject_id: subject.id,
        grade_group_id: grade.group_id,
        type_name: "课程",
        grade_id: grade.id,
        proto_parent_id: course.proto_id)
    end if data_params[:attrs]
    render(:json => {code: 0, message: "success"}.to_json, :callback => params['callback'])
  end

  def material
    material = Material.where(proto_id: data_params[:id]).first_or_create(
      name: data_params[:name],
      number: data_params[:number],
      proto_course_id: data_params[:courseId])
    data_params[:attrs].each do |att|
      m = Material.where(proto_id: att[:id]).first_or_create(
        name: att[:name],
        number: att[:index],
        proto_course_id: material.proto_course_id,
        proto_parent_id: material.proto_id)
    end if data_params[:attrs]
    render(:json => {code: 0, message: "success"}.to_json, :callback => params['callback'])
  end

  def kno_ins
    material = Material.where(proto_id: data_params[:materialsId]).last
    if material.blank?
      return render(:json => {code: 1, message: "materials #{data_params[:materialsId]} not found"}.to_json, :callback => params['callback'])
    end
    @course = material.course
    @subject = @course.subject
    @paper = Paper.where(proto_id: data_params[:id]).first_or_create(
      name: data_params[:name],
      proto_material_id: data_params[:materialsId],
      number: data_params[:number],
      type_name: data_params[:type]
    )
    SectionsService.new(@paper, JSON.parse(data_params[:content], symbolize_names: true)).exec if data_params[:content].present?
    render(:json => {code: 0, message: "success"}.to_json, :callback => params['callback'])
  end

  def que_set
    material = Material.preload(course: :subject).where(proto_id: data_params[:materialsId]).last
    if material.blank?
      return render(:json => {code: 1, message: "materials #{data_params[:materialsId]} not found"}.to_json, :callback => params['callback'])
    end
    @course = material.course
    @subject = @course.subject
    paper = Paper.where(proto_id: data_params[:id]).first_or_initialize(
      name: data_params[:name],
      proto_material_id: data_params[:materialsId],
      number: data_params[:number],
      type_name: "chapter_exam",
    )
    if exam_params # queId 为nil的是左边题型的分组
      paper.content = exam_params.select{|e| !e[:queId].present?}.map{|e| {groupId: e[:groupId], groupName: e[:groupName]}}
    end
    unless paper.save
      return render :json => {code: 1, message: paper.errors.full_messages.join(";")}.to_json, :callback => params['callback']
    end
    error_elements = []
    exam_params.select{|e| e[:queId].present? }.each_with_index do |exam_param, idx|
      # exam_param 每一条实际都是一个question，为了能沿用目前的数据结构，把question的proto id当作exmapaper proto id 放入作为唯一约束
      element = ExamPaperElement.where(proto_id: exam_param[:queId]).first_or_initialize(
        proto_paper_id: paper.proto_id,
        contentType: 5, # QUESTION 固定5
        number: idx,
        contentTypeCode: "QUESTION",
        proto_question_id: exam_param[:queId],
      )
      if element.save
          ques = exchange_to_question(exam_param)
          question_service = QuestionService.new(element, @subject, ques)
          question_service.build_question(ques,
            parent_id: ques[:parentId],
            root_id: ques[:rootId],
            number: ques[:number]
          )
      else
        error_elements << element
      end
    end if exam_params
    if error_elements.present?
      Rails.logger.error(error_elements.map{|p| p.errors.full_messages.join(";")}.join(". ") )
      render :json => {code: 1, message: "fail"}.to_json, :callback => params['callback']
    else
      render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
    end
  end

  # 把不规范的question数据转换成规范的数据
  def exchange_to_question(exam_param)
    prepare_params = exam_param.slice(
      :queId,
      :parentId,
      :difficulty,
      :content,
      :answer,
      :analysis,
      :voiceText,
      :translatidText,
      :isDecidable,
      :rootId)
    prepare_params.merge(
      number: exam_param[:parentId].present? && exam_param[:parentId] != "0" ? exam_param[:sort] : 0,
      childList: exam_param[:childQuestionList],
      keyword: exam_param[:keywords],
      answerOptionList: exam_param[:answerOptionPojoList],
      organizationList: exam_param[:hierarchyPojoList],
      questionSourceList: exam_param[:questionItemPojoList],
      writtenQuesTypeName: exam_param[:wqtName],
      writtenQuesTypeId: exam_param[:groupId], # writtenQuesTypeId 在普通试卷中表示字面意思，在课程的试题里面表示试卷的分类组的id
      deleted: 0,
      gradeGroupId: @course.grade_group_id,
    )
  end

  def data_params
    params[:data]
  end

  def exam_params
    params[:data][:data]
  end


end
