class Category < ApplicationRecord
  has_ancestry
  has_many :products
  has_many :pictures, as: :imageable
  accepts_nested_attributes_for :pictures, :reject_if => lambda { |a| a['name'].blank? }, :allow_destroy => true

  default_scope { order(:position) }

  scope :actived, -> { where(active: true) }

  def self.leaves
    self.select { |catgory| catgory.is_childless? }
  end

  def level
    self.depth + 1
  end

  def product_items
    self.subtree.map { |category| category.products }.flatten
  end

  def has_products?
    product_items.any?
  end
end
