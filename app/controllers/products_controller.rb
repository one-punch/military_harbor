class ProductsController < ApplicationController

  def index
    if params[:category_id]
      @products = PrimeryProduct.find_by_category(params[:category_id])
                                .where(active: true, parent_id: nil)
      @category = Category.find(params[:category_id])
    else
      @products = PrimeryProduct.where(active: true)
    end
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%") if params[:q]
    @products = @products.page(params[:page])
  end

  def show
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
  end


end
