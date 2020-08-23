class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper
  include PapersHelper
  before_action :logged_in_user

  helper_method :current_cart, :cart_items

  def current_cart
    current_user.present? && Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  def cart_items
    current_cart.cart_items
  end

  def validate_geetest
    if behavior_verification_params[:geetest_challenge] && behavior_verification_params[:geetest_validate] && behavior_verification_params[:geetest_seccode]
      geetest_config = Setting.geetest_config
      sdk = Geetest.new geetest_config[:id], geetest_config[:key]
      unless sdk.success_validate behavior_verification_params[:geetest_challenge], behavior_verification_params[:geetest_validate], behavior_verification_params[:geetest_seccode]
        flash[:warning] = t("validate_geetest_fail")
        redirect_back(fallback_location: login_url) and return
      end
    else
      flash[:warning] = t("missing_params")
      redirect_back(fallback_location: login_url) and return
    end
  end

  def behavior_verification_params
    params.permit(:geetest_challenge, :geetest_validate, :geetest_seccode)
  end

  private



  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
