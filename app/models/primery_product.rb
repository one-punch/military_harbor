class PrimeryProduct < ApplicationRecord

  self.table_name = :products

  has_many :images, as: :source, dependent: :destroy, autosave: true, class_name: 'Attachment'

  validates :price, numericality: true
  validates :purchase_price, numericality: true, allow_blank: true

  def is_master?
    parent_id.blank?
  end

  def is_sku?
    !is_master?
  end

end
