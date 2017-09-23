class Variant < PrimeryProduct

  default_scope {where("products.parent_id IS NOT NULL")}

  belongs_to :parent, class_name: 'Product', foreign_key: 'parent_id'
  has_one :property

  delegate :key, :value, to: :property, prefix: false, allow_nil: false

end
