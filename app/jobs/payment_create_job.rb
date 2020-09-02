class PaymentCreateJob < ApplicationJob
  queue_as :order

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order
    pay = PaymentService.new(order, SecureRandom.hex)
    if pay.exec
      attrs = {expired_at: Time.zone.now + YAML_CONFIG[:wx_alipay][:expire].minutes, extension: pay.extension}
      if pay.qr_url
        attrs.merge! qrcode_url: pay.qr_url
      end

      if pay.order_price >= order.total
        attrs.merge! total: pay.order_price
      end
      order.update_attributes(attrs)
    end
  end


end