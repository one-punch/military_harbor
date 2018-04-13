class Admin::UsersController < Admin::ApplicationController
  before_action :find_user

  def index
    @users = User.page(params[:page])
  end

  def show

  end

  def edit

  end

  def update

  end

  private

  def find_user
    @user = User.find(params[:id]) if params[:id]
  end
end