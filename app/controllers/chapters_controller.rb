class ChaptersController < ApplicationController
  layout 'pure'

  def show
    @product = Variant.preload(paper: :exam_paper_elements).find params[:id]
    @knowledge = @product.paper
    @exam_paper_elements = @knowledge.exam_paper_elements.preload(:question).order("CAST(number AS UNSIGNED)")
    @titles = @exam_paper_elements.select{|e| e.is_h1? || e.is_h2?}
  end

  def edit
    @product = Variant.preload(paper: :exam_paper_elements).find params[:id]
    @exam = @product.paper
    @exam_paper_elements = @exam.exam_paper_elements.preload(question: :childList).order("CAST(number AS UNSIGNED)")
  end

end
