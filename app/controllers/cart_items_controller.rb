class CartItemsController < ApplicationController

  before_action :find_item, only: [:update]

  def index
    @cart_items = current_cart.cart_items
  end

  def create
    @cart = current_cart
    cart_item = @cart.add_item item_params
    if cart_item.save
      redirect_to cart_path
    end
  end

  def update
    if @item.update quantity_params
      redirect_to cart_path
    end
  end

  def destroy
    @item = current_cart.cart_items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js
    end
  end

  def toggle
    if (item = current_cart.cart_items.where("cart_items.product_id" => item_params[:product_id]).last)
      @destroy = item.destroy
    else
      @cart = current_cart
      cart_item = @cart.add_item item_params
      @add_item = cart_item.save
    end
  end

  def info
    @product = PrimeryProduct.find params[:id]
    if @product.is_virtual?
      @product = @product.becomes(VirtualProduct)
    elsif  @product.is_master?
      @product = @product.becomes(Product)
    else
      @product = @product.becomes(Variant)
    end
    @had = can_read?(@product)
    @exists = current_cart.cart_items.where("cart_items.product_id" => @product.id).exists?
    render partial: "info"
  end

  private

  def find_item
    @item = current_cart.cart_items.find(params[:id]) if params[:id]
  end

  def item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def quantity_params
    params.require(:cart_item).permit(:quantity)
  end

end