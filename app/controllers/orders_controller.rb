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
    @order = Order.generate(order_params.merge(user_id: current_user.id, email: current_user.email), current_cart)
    if @order && !@order.new_record?
      flash[:success] = t("order_success")
      redirect_to @order
    else
      render :new
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
