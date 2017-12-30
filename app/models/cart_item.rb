class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product, class_name: 'PrimeryProduct', foreign_key: 'product_id'
end