class ChaptersController < ApplicationController
  layout 'chapter'

  def show
    @knowledge = Paper.kno_ins.where(proto_id: "8aac49074ebb3d6e014ecd6224950397").take
    @exam_paper_elements = @knowledge.exam_paper_elements.preload(:question).order("CAST(number AS UNSIGNED)")
    @titles = @exam_paper_elements.select{|e| e.is_h1? || e.is_h2?}
  end

  def edit
    @exam = Paper.where(type_name: 'exam', proto_id: "345b2aafffa677c398de2867c517f8e8").take
    @exam_paper_elements = @exam.exam_paper_elements.preload(question: :childList).order("CAST(number AS UNSIGNED)")
  end

end
