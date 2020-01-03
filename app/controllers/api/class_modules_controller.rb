class Api::ClassModulesController < Api::ApplicationController

  def create
    case params[:code]
    when "course"
      course
    when "material"
      material
    when "paper"
      paper
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

  def paper
    material = Material.where(proto_id: data_params[:materialsId]).last
    if material.blank?
      return render(:json => {code: 1, message: "materials #{data_params[:materialsId]} not found"}.to_json, :callback => params['callback'])
    end
    Paper.where(proto_id: data_params[:id]).first_or_create(
      name: data_params[:name],
      proto_material_id: data_params[:materialsId],
      number: data_params[:number],
      type_name: data_params[:type],
      content: data_params[:content]
    )
    render(:json => {code: 0, message: "success"}.to_json, :callback => params['callback'])
  end

  def data_params
    params[:data]
  end


end
