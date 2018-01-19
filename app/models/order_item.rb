class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, class_name: 'PrimeryProduct', foreign_key: 'product_id'
end