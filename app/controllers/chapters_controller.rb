class ChaptersController < ApplicationController

  def show
    @knowledge = Paper.kno_ins.last
  end

end
