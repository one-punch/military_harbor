class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.thank_buy.subject
  #
  def thank_buy order
    @order = order
    @user  = order.user

    mail to: @user.email, bcc: ENV[MH_MAIL], subject: "[Military Harbor] Thank you for purchase"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.sent.subject
  #
  def sent
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
