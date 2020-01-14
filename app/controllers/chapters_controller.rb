class ChaptersController < ApplicationController

  def show
    @knowledge = Paper.kno_ins.where(proto_id: "8aac49074ebb3d6e014ecd6224950397").take
    @exam_paper_elements = @knowledge.exam_paper_elements.preload(:question).order("CAST(number AS UNSIGNED)")
    @titles = @exam_paper_elements.select{|e| e.is_h1? || e.is_h2?}
    render layout:  'chapter'
  end

end
