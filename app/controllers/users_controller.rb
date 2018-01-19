class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:edit, :update, :profile]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Military Harbor"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show

  end

  def profile
    @user = current_user

    render :show
  end

  def settings
    @user = current_user

    render :edit
  end

  def edit

  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
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