class HomeController < ApplicationController

  def index
    @products = PrimeryProduct.limit 6
  end
end