class ChaptersController < ApplicationController

  def show
    @knowledge = Paper.kno_ins.where(proto_id: "8aac49074ebb3d6e014ecd6224950397").take
    @titles = @knowledge.exam_paper_elements.order("CAST(number AS UNSIGNED)").select{|e| e.is_h1? || e.is_h2?}
  end

end
