class ProductsController < ApplicationController

  def index
    @products = Product.where(active: true)
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%") if params[:q]
    @products = @products.page(params[:page])
  end

  def show
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
  end

end
