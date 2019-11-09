class UserFavoritesController < ApplicationController

  def index
    @favorites = current_user.user_favorites.preload(:item).page(params[:page]).per(params[:per] || 24)
  end

  def create
    model = params[:item_type].to_s
    unless model
      @message = "缺少参数"
      return render
    end
    if current_user.user_favorites.count < current_user.favorite_count
      item = model.constantize.find params[:item_id]
      favorite = current_user.user_favorites.where(item_type: item.class.name, item_id: item.id).first_or_initialize
      unless favorite.new_record?
        # 存在就删除
        @success = favorite.destroy
        @message = "收藏已移除"
      else
        # 不存在就新建
        @success = favorite.save
        @message = "收藏成功"
      end
    else
      @message = "超过用户最大收藏数量：#{current_user.favorite_count}"
      render
    end
  end

  def destroy
    @favorite = current_user.user_favorites.find params[:id]
    @success = @favorite.destroy
  end

end
