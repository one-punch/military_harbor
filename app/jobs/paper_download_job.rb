class PaperDownloadJob < ApplicationJob
  queue_as :default

  def perform(paper_id)
    paper = Paper.find paper_id
    if paper.student.present? &&  paper.student_file.blank?
      filename = DownloadService.new(paper.student, "/store/#{paper.path}").exec
      paper.update_attributes(student_file: "#{paper.path}/#{filename}")
    end

    if paper.teacher.present? && paper.teacher_file.blank?
      filename = DownloadService.new(paper.teacher, "/store/#{paper.path}/teacher").exec
      paper.update_attributes(teacher_file: "#{paper.path}/teacher/#{filename}")
    end
  end

end