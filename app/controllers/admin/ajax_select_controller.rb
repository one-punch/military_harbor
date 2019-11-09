class Admin::AjaxSelectController < Admin::ApplicationController

  def category
    page = params[:page] ? params[:page].to_i : 1
    per = params[:per] ? params[:per].to_i : 24
    if params[:q].present?
      @categories = Category.where(is_leaf: true).where("name LIKE ?", "%#{params[:q].strip}%").page(page).per(per)
    else
      @categories = Kaminari.paginate_array([], total_count: 1).page(1).per(1)
    end
    @options = @categories.map {|category| {text: category.name, id: category.id } }

    render json: {
        code: 0,
        message: "success",
        results: @options,
        more: @options.present? && !@categories.last_page?
      }
  end

end
