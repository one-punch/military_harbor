class PaperDownloadJob < ApplicationJob
  queue_as :default

  def perform(paper_id)
    paper = Paper.find paper_id
    if paper.student.present? &&  paper.student_file.blank?
      filename = DownloadService.new(paper.student, "/store/#{paper.path}").exec
      paper.student_file = "#{paper.path}/#{filename}"
    end

    if paper.tearcher.present? && paper.tearcher_file.blank?
      filename = DownloadService.new(paper.student, "/store/#{paper.path}").exec
      paper.tearcher_file = "#{paper.path}/#{filename}"
    end
    paper.save
  end

end