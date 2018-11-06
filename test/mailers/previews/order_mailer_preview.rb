# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/thank_buy
  def thank_buy
    order = Order.first
    OrderMailer.thank_buy order
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/sent
  def sent
    OrderMailer.sent
  end

end
