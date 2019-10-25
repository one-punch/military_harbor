class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation id
    @user = User.find id
    @user.instance_eval{create_activation_digest}
    @user.save
    mail to: @user.email, subject: "[#{I18n.t('full_title')}] Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset id
    @user = User.find id
    @user.create_reset_digest
    mail to: @user.email, subject: "[#{I18n.t('full_title')}] Passoword reset"
  end
end
