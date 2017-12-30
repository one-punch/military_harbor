class CartItemsController < ApplicationController

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

  private

  def item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

end