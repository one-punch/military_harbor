class ProductsController < ApplicationController

  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @products = PrimeryProduct.where(active: true, parent_id: nil, category_id: [@category.subtree_ids])
    else
      @products = PrimeryProduct.where(active: true)
    end
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%").or(@products.where('lower(sku) LIKE ? ', "%#{params[:q].downcase}%")) if params[:q]
    @products = @products.page(params[:page]).per(27)
  end

  def show
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
  end


end
