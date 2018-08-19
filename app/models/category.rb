class Category < ApplicationRecord
  has_ancestry
  has_many :products

  def level
    self.depth + 1
  end

  def self.leaves
    self.select { |catgory| catgory.is_childless? }
  end

  def product_items
    self.subtree.map { |category| category.products }.flatten
  end

  def has_products?
    product_items.any?
  end
end
