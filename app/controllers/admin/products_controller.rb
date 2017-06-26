class Admin::ProductsController < Admin::ApplicationController

  def index
    @products = Product.page(params[:page])
  end

  def show
    @product = Product.find params[:id]
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      redirect_to action: :images, product_id: @product.id
    else

    end
  end

  def edit

  end

  def update

  end

  def delete

  end

  def images
    @product = Product.find params[:product_id]
  end

  def upload
    @product = Product.find params[:product_id]
    @errors = []
    params[:product][:images].each do |img_file|
      img = @product.images.build(file: img_file)
      unless img.save
        @errors << img.errors.full_messages.join("; ")
      end
    end
    @product.images.reload
  end

  private

  def product_params
    params.require(:product).permit(:name, :sku, :description, :price, :purchase_price, :active)
  end

end
