class ProductsController < ApplicationController
  before_action :find, only: [:show, :student, :teacher]

  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @products = PrimaryProduct.where(active: true, parent_id: nil, category_id: [@category.subtree_ids])
    else
      @products = PrimaryProduct.where(active: true)
    end
    if params[:q]
      if params[:q].include?(",")
        params[:q].split(",").each do |q|
          @products = @products.where('lower(name) LIKE ? ', "%#{q.downcase}%").or(@products.where('lower(sku) LIKE ? ', "%#{q}%"))
        end
      else
        @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%").or(@products.where('lower(sku) LIKE ? ', "%#{params[:q].downcase}%"))
      end
    end
    @products = @products.page(params[:page]).per(24)
  end

  def show
    if @product.paper_id.present?
      PaperDownloadJob.perform_later @product.paper_id
    end
  end

  def student
    if can_read?(@product) && @product.paper&.student&.present?
      token = PaperViewerService.prepare(current_user, @product.paper_id, :student)
      @url = paper_path(token: token) # "paper-#{token}"
      render "viewer", layout: "viewer"
    else
      flash[:error] = "没有权限查看"
      redirect_to :back
    end
  end

  def teacher
    if can_read?(@product) && @product.paper&.teacher&.present?
      token = PaperViewerService.prepare(current_user, @product.paper_id, :teacher)
      @url = paper_path(token: token) # "paper-#{token}"
      render "viewer", layout: "viewer"
    else
      flash[:error] = "没有权限查看"
      redirect_to :back
    end
  end

  def filters
    @category = Category.find(params[:category_id])
    @children = @category.children.actived
    if params[:q]
      if params[:q].include?(",")
        params[:q].split(",").each do |q|
          @children = @children.where('lower(name) LIKE ? ', "%#{q.downcase}%")
        end
      else
        @children = @children.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%")
      end
    end
    render partial: "filters"
  end

  private

  def find
    @product = PrimaryProduct.find params[:id]
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
