class Admin::VirtualProductsController < Admin::ApplicationController

  before_action :init, only: [:edit, :show, :actual_products, :products, :add]

  def index
    @products = VirtualProduct.page(params[:page])
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%").or(@products.where('lower(sku) LIKE ? ', "%#{params[:q].downcase}%")) if params[:q]
  end

  def new
    @product = VirtualProduct.new
  end


  def create
    @product = VirtualProduct.new product_params.merge(is_virtual: true)
    if @product.save
      redirect_to admin_product_images_path(product_id: @product.id)
    else
      flash.now[:error] = @product.errors.full_messages.join "; "
      render :new
    end
  end

  def edit

  end

  def show

  end

  def destroy

  end


  def actual_products
  end

  def add
    Product.where(id: product_params[:actual_products]).each do |product|
      @product.virtual_product_actual_products.build(actual_product_id: product.id)
    end
    @success = false
    if @product.save
      @success = true
      flash[:success] = I18n.t("admin.success")
    else
      @message = @product.errors.full_messages.join "; "
    end
  end

  def products

  end

  private

  def init
    @product = VirtualProduct.find params[:id]
  end

  def product_params
    params.require(:virtual_product).permit(:name, :sku, :description, :price, :purchase_price, :weight, :active, :category_id, :product_detail_id, :actual_products,
                                    pictures_attributes: [:id, :name, :_destroy],
                                    properties_attributes: [:id, :key, :value, :_destroy])
  end


end
