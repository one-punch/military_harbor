class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

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

  def weight_total
    cart_items.map(&:weight).sum
  end

  def shipping_total
    weight = weight_total
    0
  end

  def total
    subtotal + shipping_total
  end

  def quantity
    cart_items.map(&:quantity).sum
  end
end
