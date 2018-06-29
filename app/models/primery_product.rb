class PrimeryProduct < ApplicationRecord

  self.table_name = :products

  has_many :images, as: :source, dependent: :destroy, autosave: true, class_name: 'Attachment'
  belongs_to :category
  belongs_to :product_detail, optional: true

  validates :price, numericality: true
  validates :purchase_price, numericality: true, allow_blank: true

  scope :active, -> { where(parent_id: nil) }

  def is_master?
    parent_id.blank?
  end

  def is_sku?
    !is_master?
  end

  def entity
    is_sku? ? Variant.find(id) : Product.find(id)
  end

  def title
    entity.name
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

  def detail_content
    description.present? ? description : product_detail.description
  end

  def self.find_by_category category_id
    category = Category.find(category_id)

    if category.has_children?
      active.where(category_id: category.child_ids)
    else
      active.where(category_id: category_id)
    end
  end

end
