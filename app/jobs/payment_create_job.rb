class PaymentCreateJob < ApplicationJob
  queue_as :order

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order
    pay = PaymentService.new(order)
    if pay.exec
      qr_url = pay.qr_url
      order.update_attributes(qrcode_url: qr_url, expired_at: Time.zone.now + YAML_CONFIG[:wx_alipay][:expire].minutes)
    end
  end


end