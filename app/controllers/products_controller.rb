class ProductsController < ApplicationController

  def show
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
  end

end
