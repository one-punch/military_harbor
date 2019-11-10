class Admin::CategoriesController < Admin::ApplicationController
  before_action :find_category, only: [:edit, :update]


  def index
    if params[:id]
      root = Category.find params[:id]
      @categories = Category.where(ancestry: "#{root.ancestry}/#{root.id}").page(params[:page])
    else
      @categories = Category.roots.page(params[:page])
    end
  end

  def show

  end

  def new
    @category = Category.new
    @category.pictures.build
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
    @category.pictures.build if @category.pictures.blank?
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
    ids = sort_params[:ids].scan(/\d+/)
    ids.each_with_index do |id, index|
      category = Category.find(id)
      category.position = index + 1
      category.save
    end

    render
  end

  private

  def find_category
    @category = Category.find(params[:id]) if params[:id]
  end

  def category_params
    params.require(:category).permit(:name, :active, :parent_id, pictures_attributes: [:id, :name, :_destroy])
  end

  def sort_params
    params.require(:category).permit(:ids)
  end
end
