class CreateUserFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :user_favorites do |t|
      t.string :user_id, null: false
      t.string :item_type, null: false
      t.integer :item_id, null: false

      t.timestamps
    end
  end
end
