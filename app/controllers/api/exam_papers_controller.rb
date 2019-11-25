module Api
  class ExamPapersController < ApplicationController

    def index
      papers = Paper.select(:proto_id).left_joins(:exam_paper_elements).where("exam_paper_elements.id is null").where("papers.type_name" => "exam")
      render :json => {code: 0, message: "success", paper_ids: papers.map(&:proto_id)}.to_json, :callback => params['callback']
    end

    def new
      material_ids = Material.distinct(:proto_course_id).joins(:course).where("courses.type_name" => "试卷").pluck(:proto_course_id)
      paper_ids = Paper.select("papers.proto_id").joins(:exam_paper_elements).where("papers.type_name" => "exam").group("papers.proto_id").having("COUNT(papers.proto_id) > 1").to_a.map(&:proto_id)
      render :json => {code: 0, message: "success", paper_ids: paper_ids, filter_ids: material_ids}.to_json, :callback => params['callback']
    end

    def create
      case params[:code]
      when "examPaperType"
        exam_paper_type
      when "examPaperFilter"
        exam_paper_filter
      when "examPaper"
        exam_paper
      when "examElement"
        exam_element
      end
    end


    def exam_paper_type
      course = Course.where(proto_id: exam_paper_params[:id]).first_or_initialize(
        name: exam_paper_params[:name],
        subject_id: exam_paper_params[:subjectId],
        grade_group_id: exam_paper_params[:gradeGroupId],
        type_name: "试卷",
        grade_id: to_grade_id(exam_paper_params[:gradeGroupId]),
        attrs: exam_paper_params[:childList])
      if course.new_record? && course.save
        render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
      else

      end
    end

    def exam_paper_filter
      material = Material.where(proto_course_id: exam_paper_params[:examPaperTypeId]).first_or_initialize(
        proto_id: SecureRandom.hex,
        name: "filters",
        attrs: exam_paper_params[:filters])
      if material.new_record? && material.save
        render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
      else
      end
    end

    def exam_paper
      error_papers = []
      exam_paper_params[:papers].each do |paper_params|
        material = Material.where(proto_course_id: paper_params[:paperTypeId]).last
        if material
          paper = Paper.where(proto_id: paper_params[:id]).first_or_initialize(
            name: paper_params[:name],
            proto_material_id: material.proto_id,
            type_name: "exam")
          if paper.new_record? && paper.save
          else
            error_papers << paper
          end
        end
      end
      if error_papers.present?
        Rails.logger.error(error_papers.map{|p| p.errors.full_messages.join(";")}.join(". ") )
      else
        render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
      end
    end

    def exam_element
      error_elements = []
      @subjects = Subject.all
      exam_paper_params[:paper][:elementList].each do |element_params|
        element = ExamPaperElement.where(proto_id: element_params[:id]).first_or_initialize(
          proto_paper_id: element_params[:paperId],
          content: element_params[:content],
          contentType: element_params[:contentType],
          axis: element_params[:axis],
          number: element_params[:sort],
          remark: element_params[:remark],
          deleted: element_params[:deleted],
          blank: element_params[:blank],
          queTypeName: element_params[:queTypeName],
          hideMainIdList: element_params[:hideMainIdList],
          hideQueIdList: element_params[:hideQueIdList],
          # question: element_params[:question],
          contentTypeCode: element_params[:contentTypeCode])
        if element.new_record? && element.save
          if (ques = element_params[:question]).present?
            subject = @subjects.find{|sub| sub.name == ques["subjectName"] }
            exam_question(subject, element, ques)
          end
        else
          error_elements << element
        end
      end
      if error_elements.present?
        Rails.logger.error(error_elements.map{|p| p.errors.full_messages.join(";")}.join(". ") )
        render :json => {code: 1, message: "fail"}.to_json, :callback => params['callback']
      else
        render :json => {code: 0, message: "success"}.to_json, :callback => params['callback']
      end
    end

    def exam_question(subject, element, ques)
      question_service = QuestionService.new(element, subject, ques)
      question_service.exec
      unless question_service.success?
        Rails.logger.error("element: #{element.id} fail, detail: #{question_service.message}")
      end
    end

    def to_grade_id(grade_group_id)
      case grade_group_id.to_i
      when Grade::GROUP['primary']
        6
      when Grade::GROUP['middle']
        9
      when Grade::GROUP['high']
        12
      end
    end

    def exam_paper_params
      params[:data]
    end

  end
end