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
      flash[:success] = "编辑成功"
      redirect_to cart_path
    end
  end

  private

  def find_item
    @item = current_cart.find(params[:id]) if params[:id]
  end

  def item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def quantity_params
    params.require(:cart_item).permit(:quantity)
  end

end