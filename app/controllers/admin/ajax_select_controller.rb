class Admin::AjaxSelectController < Admin::ApplicationController

  def category
    page = params[:page] ? params[:page].to_i : 1
    per = params[:per] ? params[:per].to_i : 24
    if params[:q].present?
      @categories = Category.all
      if params[:is_leaf].present? && params[:is_leaf] == "0"
        @categories = @categories.where(is_leaf: false)
      else
        @categories = @categories.where(is_leaf: true)
      end
      @categories = @categories.where("name LIKE ?", "%#{params[:q].strip}%").page(page).per(per)
    else
      @categories = Kaminari.paginate_array([], total_count: 1).page(1).per(1)
    end
    @options = @categories.map {|category| {text: category.path.map(&:name).join(" > "), id: category.id } }

    if params[:is_leaf].present? && params[:is_leaf] == "0"
      @options = @options.unshift({ text: '一级类目', id:  nil })
    end
    render json: {
        code: 0,
        message: "success",
        results: @options,
        more: !@categories.last_page?
      }
  end

  def product
    page = params[:page] ? params[:page].to_i : 1
    per = params[:per] ? params[:per].to_i : 24
    if params[:q].present?
      @products = Product.unscoped.select(:id, :name, :category_id).preload(:category).where("is_virtual = true OR parent_id IS NOT NULL").where("name LIKE ?", "%#{params[:q].strip}%").page(page).per(per)
    else
      @products = Kaminari.paginate_array([], total_count: 1).page(1).per(1)
    end
    @options = @products.map do |product|
      category_path = product.category.path.map(&:name).join(" > ")
      {text: "[#{category_path}] #{product.name}", id: product.id }
    end
    render json: {
        code: 0,
        message: "success",
        results: @options,
        more: !@products.last_page?
      }
  end

  def user
    page = params[:page] ? params[:page].to_i : 1
    per = params[:per] ? params[:per].to_i : 24
    if params[:q].present?
      @users = User.select(:id, :name, :email).where("name LIKE ? OR email LIKE ? ", "%#{params[:q].strip}%", "%#{params[:q].strip}%").page(page).per(per)
    else
      @users = Kaminari.paginate_array([], total_count: 1).page(1).per(1)
    end
    @options = @users.map do |user|
      {text: "[#{user.name}] #{user.email}", id: user.id }
    end
    render json: {
        code: 0,
        message: "success",
        results: @options,
        more: !@users.last_page?
      }
  end

end
