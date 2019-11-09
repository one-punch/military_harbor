class UserFavoriteCount < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :favorite_count, :integer, default: 24
  end
end
