class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product, class_name: 'PrimeryProduct', foreign_key: 'product_id'

  def subtotal
    product.price * quantity
  end
end