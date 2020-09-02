class OrdersController < ApplicationController

  skip_before_action :logged_in_user, only: [:payment_callback]

  def index
    @page = params[:page].to_i
    @orders = current_user.orders.preload(order_items: {product: [:images, :pictures]}).order("created_at DESC").page(@page).per(10)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    @order = current_user.orders.new
  end

  def create
    @order = Order.generate({user_id: current_user.id, email: current_user.email}, current_cart)
    if @order && !@order.new_record?
      PaymentCreateJob.new.perform(@order.id)
      CancelOrderJob.set(wait: 30.minutes).perform_later
      flash[:success] = t("order_success")
      redirect_to @order
    else
      render :new
    end
  end

  def payment
    @order = current_user.orders.find_by(id: params[:id])
    if @order
      render json: {
        code: 0,
        message: I18n.t("success"),
        data: {
          id: @order.id,
          confirmed: @order.confirm?,
          qrcode_expired: @order.qrcode_expired?
        }
      }
    else
      render json: {
        code: 404,
        message: I18n.t("order_not_found"),
        data: nil
      }
    end
  end

  def payment_callback
    # order_id 、qr_price（实际支付金额） 、extension 和 sign, 加密方式为 md5(md5(order_id) + secretkey)
    if params[:sign].blank? || params[:order_id].blank?
      return render(json: {
        code: 1001,
        message: I18n.t("missing_params"),
        data: nil
      })
    end
    my_sign = Digest::MD5.hexdigest(Digest::MD5.hexdigest(params[:order_id].to_s) + YAML_CONFIG[:wx_alipay][:secretkey])
    if params[:sign].to_s == my_sign
      @order = Order.preload(order_items: :product).find_by(id: params[:order_id], status: :wait_payment, extension: params[:extension])
      unless @order
        return render(json: {
            code: 404,
            message: I18n.t("order_not_found"),
            data: nil
        })
      end
      if @order && @order.total <= params[:qr_price].to_f && @order.update_attributes(status: :paid)
        service = OrderService.new(@order)
        service.processing
      end
      return render(json: {
          code: 0,
          message: I18n.t("success"),
          data: nil
      })
    else
      Rails.logger.error("#{I18n.t("sign_miss_match")}, sign: #{params[:sign]} expect: #{my_sign}, order_id: #{params[:order_id]}")
      return render(json: {
        code: 1002,
        message: I18n.t("sign_miss_match"),
        data: nil
      })
    end
  end

  private

end
