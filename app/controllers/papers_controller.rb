class PapersController < ApplicationController

  def show
    val = PaperViewerService.pop(current_user, params[:token])
    if val && (paper_id = val["id"]) && (type = val["type"]) && can_view?(paper_id)
      @paper = Paper.find paper_id
      case type
      when 'teacher'
        file_path = @paper.teacher_file
      else
        file_path = @paper.student_file
      end
      send_file "#{Rails.root}/store/#{file_path}", :disposition => 'inline'
    else
      render_404
    end
  end

  def student_exam
    @paper = Paper.preload(:exam_paper_elements).find params[:id]
  end

  def teacher_exam
    @paper = Paper.preload(:exam_paper_elements).find params[:id]
  end


end
