class Admin::OrdersController < Admin::ApplicationController
  before_action :find_order, only: [:show, :edit, :update]

  def index
    @orders = Order.includes(:user, :order_items).order('created_at DESC')
    if params[:date].present?
      date = Date.parse(params[:date])
      @orders = @orders.where(created_at: date.beginning_of_day..date.end_of_day)
    end
    @orders = @orders.where(id: (params[:id].to_i - 10000)) if params[:id].present?
    @orders = @orders.joins(:user).where('lower(users.name) LIKE ? ', "%#{params[:user].downcase}%") if params[:user].present?
    @orders = @orders.where(status: params[:status]) if params[:status].present?
    @orders = @orders.page(params[:page])
  end

  def new
    @order = Order.new
  end

  def create
    @product = PrimaryProduct.find params[:product_id]
    @user = User.find order_params[:user_id]
    if @product.is_virtual || @product.is_sku?
      cart = Cart.create
      cart.add_item({product_id: @product.id, quantity: 1})
      cart.save
      @order = Order.generate(order_params.merge(email: @user.email), cart)
      if !@order.new_record?
        redirect_to admin_order_path(@order)
      else
        flash[:error] = @order.errors.full_messages.join("; ")
        render :new
      end
    else
      flash[:error] = "不允许使用此产品创建订单"
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    if @order.update_attributes order_params
      service = OrderService.new(@order)
      service.processing
      flash[:success] = "order updated"
      redirect_to admin_order_path(@order)
    else
      render admin_order_path(@order)
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id)
  end

  def find_order
    @order = Order.find(params[:id]) if params[:id]
  end

  def order_params
    params.require(:order).permit(:user_id,
                                  :pay,
                                  :pay_number,
                                  :status,
                                  )
  end
end
