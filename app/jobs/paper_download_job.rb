class PaperDownloadJob < ApplicationJob
  queue_as :default

  def perform(paper_id)
    paper = Paper.find paper_id
    if paper.student.present? &&  paper.student_file.blank?
      begin
        filename = DownloadService.new(paper.student, "/store/#{paper.path}").exec
        paper.update_attributes(student_file: "#{paper.path}/#{filename}")
      rescue Exception => e
        Rails.logger.error(e)
      end
    end

    if paper.teacher.present? && paper.teacher_file.blank?
      begin
        filename = DownloadService.new(paper.teacher, "/store/#{paper.path}/teacher").exec
        paper.update_attributes(teacher_file: "#{paper.path}/teacher/#{filename}")
      rescue Exception => e
        Rails.logger.error(e)
      end
    end
  end

end