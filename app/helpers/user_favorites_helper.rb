module UserFavoritesHelper

  def favorites(item)
    icon = current_user.user_favorites.where(item_type: item.class.name, item_id: item.id).exists? ? "glyphicon glyphicon-star" : "glyphicon glyphicon-star-empty"
    id = SecureRandom.hex
    link_to user_favorites_path(item_type: item.class.name, item_id: item.id, element: id), remote: true, method: :POST, id: id do
      %Q{<button type="button" class="btn btn-default">
        <span class="#{icon}" aria-hidden="true"></span>
      </button>}.html_safe
    end
  end

  def favorites_link(favorite)
    if favorite.is_category?
      products_path(category_id: favorite.item_id)
    elsif favorite.is_product?
      product_path(favorite.item_id, name: favorite.item_name)
    end
  end

end
