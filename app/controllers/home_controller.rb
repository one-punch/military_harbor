class HomeController < ApplicationController

  def index
    @categories = Category.roots.actived.select { |category| category.pictures.any? }
    @products = Product.limit 12
  end
end
