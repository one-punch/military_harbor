class ChaptersController < ApplicationController

  def show
    @knowledge = Paper.kno_ins.last
    @titles = @knowledge.exam_paper_elements.order("number").select{|e| e.is_h1? || e.is_h2?}
  end

end
