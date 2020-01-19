class PrimaryProduct < ApplicationRecord

  self.table_name = :products

  has_many :images, as: :source, dependent: :destroy, autosave: true, class_name: 'Attachment'
  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :pictures, :reject_if => lambda { |a| a['name'].blank? }, :allow_destroy => true
  belongs_to :category
  belongs_to :product_detail, optional: true
  has_many :user_favorites

  validates :sku, presence: true, uniqueness: true
  validates :price, numericality: true
  validates :purchase_price, numericality: true, allow_blank: true

  delegate :id, :name, to: :category, prefix: true, allow_nil: true

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

  def free_shipping?
    weight < 0.2
  end

  def currency_price
    "#{'%.2f' % price} 元"
  end

  def allow_checkout?
    (is_master? && !Variant.where(parent_id: id).exists?) || is_sku?
  end

  def default_images format=:thumb
    return images.map {|i| i.file_url(format) } if images.any?
    pictures.map {|p| p.url }
  end

  def product_images(format=:thumb)
    if is_sku?
      default_images(format).any? ? default_images(format) : Product.find(parent_id).default_images
    else
      default_images(format)
    end
  end

  def default_image(format=:thumb)
    product_images(format).first || "/img/course#{rand(1..3)}.jpg"
  end

  def detail_content
    product_detail.description if product_detail.present?
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
