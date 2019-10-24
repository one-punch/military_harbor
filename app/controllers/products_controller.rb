class ProductsController < ApplicationController
  before_action :find, only: [:show, :student, :teacher]

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
    if @product.paper_id.present?
      PaperDownloadJob.perform_later @product.paper_id
    end
  end

  def student
    if can_read?(@product) && @product.paper&.student&.present?
      token = PaperViewerService.prepare(current_user, @product.paper_id)
      @url = paper_path(token: token) # "paper-#{token}"
      render "viewer", layout: "viewer"
    else
      flash[:error] = "没有权限查看"
      redirect_to :back
    end
  end

  def teacher
    if can_read?(@product) && @product.paper&.teacher&.present?
      token = PaperViewerService.prepare(current_user, @product.paper_id)
      @url = paper_path(token: token) # "paper-#{token}"
      render "viewer", layout: "viewer"
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
