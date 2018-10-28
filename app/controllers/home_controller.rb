class HomeController < ApplicationController

  def index
    @categories = Category.roots.select { |category| category.pictures.any? }
    @products = Product.limit 12
  end
end
