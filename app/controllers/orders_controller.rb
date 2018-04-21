class OrdersController < ApplicationController

  before_action :logged_in_user, only: [:index, :new, :create]

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @order = current_user.orders.new
  end

  def create
    @order = current_user.orders.new(order_params)
    order_saved = false
    ActiveRecord::Base.transaction do
      begin
        @order.status = :wait_payment
        @order.save!
        cart_items.each do |cart_item|
          @order.order_items.create!(product_id: cart_item.product_id, price: cart_item.product.price, quantity: cart_item.quantity)
        end

        current_cart.destroy!

        order_saved = true
      rescue Exception => e
        order_saved = false
        flash[:error] = e
        raise ActiveRecord::Rollback
      end
    end

    if order_saved
      flash[:success] = "The order was successful"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def order_params
    params.require(:order).permit(:first_name,
                                  :last_name,
                                  :email,
                                  :phone,
                                  :country,
                                  :province,
                                  :city,
                                  :zip,
                                  :street,
                                  :description,
                                  :pay,
                                  :pay_number)
  end

end