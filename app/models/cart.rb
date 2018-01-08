class Cart < ApplicationRecord
  has_many :cart_items

  def add_item params
    item = cart_items.find_by(product_id: params[:product_id])
    if item
      item.quantity += params[:quantity].to_i
    else
      item = cart_items.build params
    end
    item
  end

  def subtotal
    cart_items.map(&:subtotal).sum
  end

  def quantity
    cart_items.map(&:quantity).sum
  end
end