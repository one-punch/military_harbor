class ProductsController < ApplicationController

  def index
    @products = if params[:category_id]
      Product.find_by_category(params[:category_id])
    else
      Product.where(active: true)
    end
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%") if params[:q]
    @products = @products.page(params[:page])
  end

  def show
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
  end

  private


end
