class Product < ApplicationRecord

  has_many :images, as: :source, dependent: :destroy, autosave: true, class_name: 'Attachment'
  has_many :property_groups
  has_many :properties

  validates :price, numericality: true
  validates :purchase_price, numericality: true, allow_blank: true


  def master?
    parent_id.blank?
  end

  def sku?
    parent_id.present?
  end

end
