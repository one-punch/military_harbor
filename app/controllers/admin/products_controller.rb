class Admin::ProductsController < Admin::ApplicationController

  def index
    @products = Product.page(params[:page])
    @products = @products.where('lower(name) LIKE ? ', "%#{params[:q].downcase}%").or(@products.where('lower(sku) LIKE ? ', "%#{params[:q].downcase}%")) if params[:q]

    respond_to do |format|
      format.html
      format.csv { send_data @products.export, filename: 'products.csv' }
    end
  end

  def show
    @product = Product.find params[:id]
  end

  def new
    @product = Product.new
    @product.pictures.build
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
      @product.variants.each { |variant| variant.update(category_id: @product.category_id) }
      flash[:success] = "update success"
      redirect_to action: :edit, id: @product.id
    else
      flash.now[:danger] = @product.errors.full_messages.join("; ")
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
    @variant.category_id = @product.category_id
    if @variant.save
      flash[:success] = "创建成功"
      redirect_to edit_admin_product_path(@variant.id)
    else
      flash.now[:danger] = @variant.errors.full_messages.join("; ")
    end
  end

  def update_variant
    @product = Product.find params[:id]
    @variant = @product.variants.find params[:variant_id]
    if @variant.update_attributes variant_params
      flash[:success] = "编辑成功"
      redirect_to edit_admin_product_path(@variant.id)
    else
      flash.now[:danger] = @variant.errors.full_messages.join("; ")
    end
  end

  def import
    if params[:file]
      Product.transaction do
        Product.import(params[:file])
      end
      flash[:success] = "导入商品成功"
    else
      flash[:danger] = "请选择上传文件"
    end
    redirect_to admin_products_path
  rescue => e
    flash[:danger] = e
    redirect_to admin_products_path
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
    params.require(:product).permit(:name, :sku, :description, :price, :purchase_price, :weight, :active, :category_id, :product_detail_id,
                                    pictures_attributes: [:id, :name, :_destroy])
  end

  def variant_params
    params.require(:variant).permit(:name, :sku, :description, :price, :purchase_price, :weight, :active, :category_id, :product_detail_id,
                                    pictures_attributes: [:id, :name, :_destroy],
                                    properties_attributes: [:id, :key, :value, :_destroy])
  end

  def property_params
    params.permit(properties: [:id, :key, :value])
  end

end
