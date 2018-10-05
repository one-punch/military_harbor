class Admin::CategoriesController < Admin::ApplicationController
  before_action :find_category, only: [:edit, :update]


  def index
    @categories = Category.roots.page(params[:page])
  end

  def show

  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "创建成功"
      redirect_to admin_categories_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @category.update(category_params)
      flash[:success] = "编辑成功"
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end

  def sort
    ids = sort_params[:ids].scan(/\d/)

    render body: nil
  end

  private

  def find_category
    @category = Category.find(params[:id]) if params[:id]
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def sort_params
    params.require(:category).permit(:parent_id, :ids)
  end
end
