class Order < ApplicationRecord

  has_many :order_items
  belongs_to :user
  belongs_to :shipper, optional: true

  enum status: [:wait_payment, :pending, :paid, :shipped, :cancel]

  enum pay: [:paypal, :western_nion]

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  validates :country, presence: true
  validates :street, presence: true
  validates :zip, presence: true
  validates :pay, presence: true

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

end
