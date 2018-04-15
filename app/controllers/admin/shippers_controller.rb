class Admin::ShippersController < Admin::ApplicationController
  before_action :find_shipper, only: [:show, :edit, :update]

  def index
    @shippers = Shipper.page(params[:page])
  end

  def new
    @shipper = Shipper.new
  end

  def create
    @shipper = Shipper.new(shipper_params)

    if @shipper.save
      flash[:success] = "创建成功"
      redirect_to admin_shippers_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @shipper.update(shipper_params)
      flash[:success] = "编辑成功"
      redirect_to admin_shippers_path
    else
      render 'edit'
    end
  end

  private

  def find_shipper
    @shipper = Shipper.find(params[:id]) if params[:id]
  end

  def shipper_params
    params.require(:shipper).permit(:name, :description)
  end
end