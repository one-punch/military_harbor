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
    @product = Variant.preload(paper: :exam_paper_elements).find params[:id]
    if can_read?(@product) && @product.paper&.is_exam?
      @paper = @product.paper
    else
      flash[:error] = "没有权限查看"
      redirect_to :back
    end
  end

  def teacher_exam
    student_exam
  end


end
