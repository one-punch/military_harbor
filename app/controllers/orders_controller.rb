class OrdersController < ApplicationController

  before_action :logged_in_user, only: [:new, :create]

  def new
    @order = current_user.orders.new
  end

  def create
    @order = current_user.orders.new(order_params)
    order_saved = false
    ActiveRecord::Base.transaction do
      begin
        @order.save!
        cart_items.each do |cart_item|
          @order.order_items.create!(product_id: cart_item.product_id, price: cart_item.product.price)
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
                                  :zip,
                                  :street,
                                  :description,
                                  :pay,
                                  :pay_number)
  end

end