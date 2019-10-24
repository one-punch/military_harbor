class SessionsController < ApplicationController

  skip_before_action :logged_in_user, only: [:new, :create]

  def new

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
