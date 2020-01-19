class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product, class_name: 'PrimaryProduct', foreign_key: 'product_id'

  def subtotal
    product.price * quantity
  end

  def weight
    product.weight * quantity
  end
end
