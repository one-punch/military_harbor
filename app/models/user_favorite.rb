class UserFavorite < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user

  delegate :name, to: :item, prefix: true, allow_nil: true

  def is_category?
    item_type == Category.name
  end

  def is_product?
    [VirtualProduct, Variant, Product, PrimaryProduct].map(&:name).include?(item_type)
  end

end
