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
      render :new
    end
  end

  def edit
    _product = PrimeryProduct.find params[:id]
    @product = _product.is_master? ? Product.find(params[:id]) : Variant.find(params[:id])
    render :edit
  end

  def update
    @product = Product.find params[:id]
    if @product.update_attributes product_params
      flash[:success] = "update success"
      redirect_to action: :edit, id: @product.id
    else
      flash[:error] = @product.errors.full_messages.join("; ")
      render :edit
    end
  end

  def destroy

  end

  def variants
    @product = Product.find params[:id]
    @variants = @product.variants
  end

  def new_variant
    @product = Product.find params[:id]
    @variant = @product.variants.build
    @property = @variant.build_property
  end

  def create_variant
    @product = Product.find params[:id]
    binding.pry
    @variant = @product.variants.build variant_params
    @property = @variant.build_property property_params
    if @variant.save
      redirect_to action: :images, product_id: @variant.id
    else
      render :new_variants
    end
  end

  def edit_variant
  end

  def update_variant
    @product = Product.find params[:id]
    @variant = @product.variants.find params[:variant_id]
    binding.pry
    if @variant.property.update_attributes(property_params) && @variant.update_attributes(variant_params)
      redirect_to action: :edit, id: @product.id
    else
      render :edit
    end
  end

  def images
    _product = PrimeryProduct.find params[:product_id]
    @product = _product.is_master? ? Product.find(params[:product_id]) : Variant.find(params[:product_id])
  end

  def upload
    _product = PrimeryProduct.find params[:product_id]
    @product = _product.is_master? ? Product.find(params[:product_id]) : Variant.find(params[:product_id])
    @errors = []
    params[:product][:images].each do |img_file|
      img = @product.images.build(file: img_file)
      unless img.save
        @errors << img.errors.full_messages.join("; ")
      end
    end
    @product.images.reload
  end

  def images_delete
    @product = PrimeryProduct.find params[:id]
    @errors = []
    @image = @product.images.find params[:image_id]
    if @image.destroy
      @errors = ''
    else
      @errors << @image.errors.full_messages.join("; ")
    end
    @product.images.reload
    render :upload
  end

  private

  def product_params
    params.require(:product).permit(:name, :sku, :description, :price, :purchase_price, :active)
  end

  def variant_params
    params.require(:variant).permit(:name, :sku, :description, :price, :purchase_price, :active)
  end

  def property_params
    params.require(:variant).require(:property).permit(:key, :value)
  end

end
