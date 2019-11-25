class MigrateQuestions < ApplicationJob
  queue_as :default

  def perform
    log_file = File.open("#{Rails.root}/log/migrate_questions.log", 'a')
    @logger = Logger.new log_file

    @subjects = Subject.all
    ExamPaperElement.where("question IS NOT NULL").find_each do |element|
      ques = JSON.parse element[:question]

      subject = @subjects.find{|sub| sub.name == ques["subjectName"] }
      question_service = QuestionService.new(element, subject, ques)
      question_service.exec

      unless question_service.success?
        @logger.error("element: #{element.id} fail, detail: #{question_service.message}")
      end
    end
  end

end