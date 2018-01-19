class Order < ApplicationRecord

  has_many :order_items
  belongs_to :user

  enum status: [:wait_payment, :paid, :pending, :shipping, :shipped]

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  validates :country, presence: true
  validates :street, presence: true
  validates :zip, presence: true
  validates :pay, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
end