class Order < ApplicationRecord

  has_many :order_items
  belongs_to :user
  # belongs_to :shipper, optional: true

  enum status: [:wait_payment, :pending, :paid, :cancel, :finish]

  # enum pay: [:wechat, :alipay]

  # validates :pay, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  def full_name
    "#{first_name} #{last_name}"
  end

  def quantity
    order_items.map(&:quantity).sum
  end

  def order_number
    10000 + id
  end

  def status_humanize
    status.humanize
  end

  def thank_buy_email
    OrderMailer.thank_buy(self).deliver_later
  end

  def confirm?
    ![:wait_payment, :pending].include?(status.to_sym)
  end

  def self.generate(order_params, cart)
    @order = Order.new(order_params)
    @order.status = :wait_payment
    @order.subtotal = cart.subtotal
    @order.shipping_total = cart.shipping_total
    @order.total = cart.total
    @order.weight = cart.weight_total
    ActiveRecord::Base.transaction do
      begin
        @order.save!
        cart.cart_items.each do |cart_item|
          @order.order_items.create!(product_id: cart_item.product_id, price: cart_item.product.price, quantity: cart_item.quantity)
        end
        cart.destroy!
      rescue Exception => e
        @order.errors.add(:base, :generate_fail, message: e.message)
        Rails.logger.error(e)
        raise ActiveRecord::Rollback
      end
    end
    @order
  end

end
