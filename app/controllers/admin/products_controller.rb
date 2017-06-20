class Admin::ProductsController < Admin::ApplicationController

  def index
    @products = Product.page(params[:page])
  end

  def show

  end

  def create

  end

  def edit

  end

  def update

  end

  def delete

  end

end
