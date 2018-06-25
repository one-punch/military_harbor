class Admin::ProductDetailsController < Admin::ApplicationController
  before_action :find_product_detail, only: [:edit, :update]

  def index
    @product_details = ProductDetail.page(params[:page])
  end

  def new
    @product_detail = ProductDetail.new
  end

  def create
    @product_detail = ProductDetail.new(product_detail_params)

    if @product_detail.save
      flash[:success] = "创建成功"
      redirect_to admin_product_details_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @product_detail.update(product_detail_params)
      flash[:success] = "编辑成功"
      redirect_to admin_product_details_path
    else
      render 'edit'
    end
  end

  private

  def find_product_detail
    @product_detail = ProductDetail.find(params[:id]) if params[:id]
  end

  def product_detail_params
    params.require(:product_detail).permit(:name, :description)
  end

end
