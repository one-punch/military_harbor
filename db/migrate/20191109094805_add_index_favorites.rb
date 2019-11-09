class AddIndexFavorites < ActiveRecord::Migration[5.1]
  def change
    add_index :user_favorites, :user_id
    add_index :user_favorites, [:item_id, :item_type]
  end
end
