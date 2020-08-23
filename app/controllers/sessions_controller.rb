class SessionsController < ApplicationController

  skip_before_action :logged_in_user, only: [:new, :create, :geetest_register]
  before_action :validate_geetest, only: [:create]

  def new

  end


  def geetest_register
    geetest_config = Setting.geetest_config
    sdk = Geetest.new geetest_config[:id], geetest_config[:key]
    begin
      result_from_gee_test_server = sdk.pre_process(SecureRandom.hex)
      if result_from_gee_test_server.present? && result_from_gee_test_server[:challenge].present?
        render json: {'code': 0, message: "success", data: result_from_gee_test_server }.to_json
      else
        render json: {'code': 100, message: "无法获取验证"}.to_json
      end
    rescue Exception => e
      Rails.logger.error(e)
      render json: {'code': 100, message: "无法获取验证"}.to_json
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember user
        redirect_back_or user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash.now[:warning] = message
        render 'new'
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
