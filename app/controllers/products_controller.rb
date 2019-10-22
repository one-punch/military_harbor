class ProductsController < ApplicationController
  before_action :find, only: [:show, :viewer]

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
  end

  def viewer
    if can_read?(@product)
      token = PaperViewerService.prepare(current_user, @product.paper_id)
      @url = paper_path(token: token) # "paper-#{token}"
      render layout: "viewer"
    else
      flash[:error] = "没有权限查看"
      redirect_to :back
    end
  end


  private

  def find
    @product = PrimeryProduct.find params[:id]
    @product = \
    if @product.is_virtual?
      @product.becomes(VirtualProduct)
    elsif @product.is_master?
      @product.becomes(Product)
    else
      @product.becomes(Variant)
    end
  end

end
