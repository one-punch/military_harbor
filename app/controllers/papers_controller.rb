class PapersController < ApplicationController

  def show
     send_file 'store/compressed.tracemonkey-pldi-09.pdf', :disposition => 'inline'
  end


end
