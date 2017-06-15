class UsersController < ApplicationController
  before_action :find_user, only: [:show, :eidt]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Military Harbor"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show

  end

  private

    def find_user
      @user = User.find(params[:id]) if params[:id]
    end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end