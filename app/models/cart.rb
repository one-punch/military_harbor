class Cart < ApplicationRecord
  has_many :cart_items

  def add_item params
    item = cart_items.find_by(product_id: params[:product_id])
    if item
      item.quantity += params[:quantity]
    else
      item = cart_items.build params
    end
    item
  end

  def subtotal
    cart_items.map(&:subtotal).sum
  end
end