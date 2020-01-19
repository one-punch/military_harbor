class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, class_name: 'PrimaryProduct', foreign_key: 'product_id'

  def subtotal
    price * quantity
  end
end