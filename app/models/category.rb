class Category < ApplicationRecord
  has_ancestry
  has_many :products
  has_many :pictures, as: :imageable
  has_many :user_favorites

  accepts_nested_attributes_for :pictures, :reject_if => lambda { |a| a['name'].blank? }, :allow_destroy => true

  default_scope { order(:position) }

  scope :actived, -> { where(active: true) }
  scope :leaves, -> { where(is_leaf: true) }

  before_save :reset_is_leaf

  def level
    self.depth + 1
  end

  def product_items
    self.subtree.map { |category| category.products }.flatten
  end

  def has_products?
    product_items.any?
  end

  def reset_is_leaf
    self.is_leaf = self.is_childless?
  end

end
