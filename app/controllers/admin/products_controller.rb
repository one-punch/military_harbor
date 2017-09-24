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
    if @product.is_master?
      @variant = @product.variants.build
    else
      flash[:error] = "Only SPU allow add Variants"
      return redirect_to :back
    end
  end

  def create_variant
    @product = Product.find params[:id]
    if @product.is_sku?
      flash[:error] = "Only SPU allow add Variants"
      return redirect_to :back
    end
    @variant = @product.variants.build variant_params
    ActiveRecord::Base.transaction do
      begin
        @variant.save!
        binding.pry
        property_params[:properties].each do |pro_param|
          binding.pry
          @variant.properties.create! pro_param.except(:id)
        end
      rescue exception => e
        flash[:error] = e.message
        raise ActiveRecord::Rollback
      end
    end
    flash[:success] = "Create success"
    redirect_to action: :images, product_id: @variant.id
  rescue Exception => e
    render :new_variant
  end

  def update_variant
    @product = Product.find params[:id]
    @variant = @product.variants.find params[:variant_id]
    ActiveRecord::Base.transaction do
      begin
        property_params[:properties].each do |pro_param|
          if pro_param[:id].present?
            _property = @variant.properties.find pro_param[:id]
            _property.update_attributes(pro_param.except(:id))
          else
            @variant.properties.create! pro_param.except(:id)
          end
        end
        @variant.update_attributes(variant_params)
      rescue Exception => e
        flash[:error] = e.message
        raise ActiveRecord::Rollback
      end
    end
    flash[:success] = "Update success"
    redirect_to action: :edit, id: @variant.id
  rescue Exception => e
    redirect_to action: :edit, id: @variant.id
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

  def delete_property
    @variant = Variant.find params[:id]
    @property = @variant.properties.find params[:property_id]
    if @property.destroy
      flash[:success] = "Destroy success"
    else
      flash[:error] = @property.errors.full_messages.join("; ")
    end
    redirect_to action: :edit, id: @variant.id
  end

  def delete_variant

  end

  private

  def product_params
    params.require(:product).permit(:name, :sku, :description, :price, :purchase_price, :active)
  end

  def variant_params
    params.require(:variant).permit(:name, :sku, :description, :price, :purchase_price, :active)
  end

  def property_params
    params.permit(properties: [:id, :key, :value])
  end

end
