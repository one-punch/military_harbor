class Product < PrimeryProduct

  default_scope {where("products.parent_id IS NULL")}

  has_many :variants, class_name: 'Variant', foreign_key: 'parent_id', dependent: :destroy

  scope :root, -> { where(parent_id: nil) }

  def has_variant?
    variants.exists?
  end
end
