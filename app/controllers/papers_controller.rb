class PapersController < ApplicationController

  def show
    paper_id = PaperViewerService.pop(current_user, params[:token])
    if paper_id && can_view?(paper_id)
      @paper = Paper.find paper_id
      file_path = @paper.student_file
      send_file 'store/compressed.tracemonkey-pldi-09.pdf', :disposition => 'inline'
    else
      render_404
    end
  end


end
