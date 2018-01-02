class PrimeryProduct < ApplicationRecord

  self.table_name = :products

  has_many :images, as: :source, dependent: :destroy, autosave: true, class_name: 'Attachment'
  belongs_to :category

  validates :price, numericality: true
  validates :purchase_price, numericality: true, allow_blank: true

  def is_master?
    parent_id.blank?
  end

  def is_sku?
    !is_master?
  end

  def currency_price
    "$#{'%.2f' % price}"
  end

  def allow_checkout?
    (is_master? && !Variant.where(parent_id: id).exists?) || is_sku?
  end

  def default_image(format)
    if is_sku? && images.blank?
      Product.find(parent_id).images.first.file_url(format)
    else
      images.first.file_url(format)
    end
  end

end
