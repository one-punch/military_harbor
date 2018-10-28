class HomeController < ApplicationController

  def index
    @products = Product.limit 12
  end
end
