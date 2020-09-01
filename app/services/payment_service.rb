# 根据订单创建用户记录
class PaymentService

  attr_accessor :order, :res, :message

  def initialize(order)
    @client = WxAlipayPersional.new
    @order = order
  end

  def exec
    begin
      @res = @client.create_order order_id: order.id, order_type: "alipay", order_price: order.total, order_name: "book#{order.id}", redirect_url: YAML_CONFIG[:wx_alipay][:callback_url], extension: nil
    rescue Exception => e
      Rails.logger.error(e)
      @message = I18n.t "create_payment_fail"
      return false
    end
    if @res.success?
      @message = I18n.t "create_payment_success"
      true
    else
      @message = res.error_message
      false
    end
  end

  def qr_url
    @res.success? ? res.result.data.qr_url : nil
  end

end