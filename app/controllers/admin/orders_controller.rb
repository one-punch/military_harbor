class Admin::OrdersController < Admin::ApplicationController
  before_action :find_order, only: [:show, :edit, :update]

  def index
    @orders = Order.includes(:user, :order_items)
    if params[:date].present?
      date = Date.parse(params[:date])
      @orders = @orders.where(created_at: date.beginning_of_day..date.end_of_day)
    end
    @orders = @orders.where(id: (params[:id].to_i - 10000)) if params[:id].present?
    @orders = @orders.joins(:user).where('lower(users.name) LIKE ? ', "%#{params[:user].downcase}%") if params[:user].present?
    @orders = @orders.where(status: params[:status]) if params[:status].present?
    @orders = @orders.page(params[:page])
  end

  def show

  end

  def edit

  end

  def update
    if @order.update_attributes order_params
      flash[:success] = "order updated"
      redirect_to admin_order_path(@order)
    else
      render admin_order_path(@order)
    end
  end

  private

  def find_order
    @order = Order.find(params[:id]) if params[:id]
  end

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
                                  :pay_number,
                                  :shipper_id,
                                  :shipping_number,
                                  :status,
                                  )
  end
end