class Api::ClassPapersController < Api::ApplicationController

  def create
    case params[:code]
    when "course"
      course
    when "papers"
      paper
    end
  end


  def course
    @subjects = Subject.all
    @grades = Grade.all
    data_params.each do |cour|
      grade = @grades.find{|g| g.id == cour[:gradeId].to_i }
      course = Course.where(proto_id: cour[:id]).first_or_initialize(name: cour[:name], grade_id: grade.id, type_name: "教材", grade_group_id: grade.group_id)
      next unless course.new_record?
      sub = @subjects.find{|sub| sub.name == cour[:subjectName] }
      course.subject_id = sub[:id] if sub
      course.attrs = cour.slice(:labelId, :labelName, :paperNum, :remark, :year, :quarterId, :quarterName, :semester, :gradeGroupId, :folderNum, :classTypeId, :cityId, :diffId, :diffName, :subjectTypeId, :subjectTypeName, :textBookId, :textBookName, :modulePurpose, :moduleType, :volumeName, :volumeId)
      course.save
    end

    render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
  end

  def paper
    data_params.each_with_index do |mater_params, idx|
      material = Material.where(proto_id: mater_params[:id]).first_or_create name: mater_params[:name], number: idx+1, proto_course_id: mater_params[:courseId]
      cloumns = [:explainPapers, :workPapers, :coursewareList]
      cloumns.each do |clo|
        mater_params[:classes][clo].each_with_index do |p, i|
            type = case clo
            when :explainPapers
              "explain"
            when :workPapers
              "work"
            when :coursewareList
              "courseware"
            else
              ""
            end
            next unless p[:name].present?
            Paper.where(proto_id: p[:id]).first_or_create name: p[:name], proto_material_id: mater_params[:id], student: p[:downloads][:student], teacher: p[:downloads][:teacher], type_name: type, number: i, path: p[:path]
        end
      end
    end
    render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
  end

  def data_params
    params[:data]
  end

end
