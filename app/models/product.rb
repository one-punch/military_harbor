class Product < ApplicationRecord

  has_many :images, as: :source, dependent: :destroy, autosave: true, class_name: 'Attachment'

  validates :price, numericality: true
  validates :purchase_price, numericality: true, allow_blank: true


end
