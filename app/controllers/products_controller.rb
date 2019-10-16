class ProductsController < ApplicationController

  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @products = PrimeryProduct.where(active: true, parent_id: nil, category_id: [@category.subtree_ids])
    else
      @products = PrimeryProduct.where(active: true)
    end
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%").or(@products.where('lower(sku) LIKE ? ', "%#{params[:q].downcase}%")) if params[:q]
    @products = @products.page(params[:page]).per(24)
  end

  def show
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
  end

  def viewer
    if can_view?(params[:id])
      token = PaperViewerService.prepare(current_user, params[:id])
      @url = paper_path(token: token)# "paper-#{token}"
      render file: 'public/viewer/viewer.html', layout: "viewer"
    else

    end
  end

end
