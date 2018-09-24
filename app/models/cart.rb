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
    if weight <= 1
      if weight > 0.2 && weight <= 0.4
        12
      elsif weight > 0.4 && weight <= 0.7
        20
      else
        25
      end
    else
      total = 30
      incre = (weight - 1.1) / 0.5
      incre.to_i / 5 + 30
    end
  end

  def total
    subtotal + shipping_total
  end

  def quantity
    cart_items.map(&:quantity).sum
  end
end
