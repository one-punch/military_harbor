class VirtualProduct < PrimeryProduct

  default_scope {where("products.is_virtual = ? ", true)}

  has_many :properties, foreign_key: :variant_id
  accepts_nested_attributes_for :properties, :reject_if => lambda { |a| ![a['key'], a['value']].all? }, :allow_destroy => true

  has_many :virtual_product_actual_products
  has_many :actual_products, class_name: "Product", through: :virtual_product_actual_products, :source => :actual_product

  def active?
    [:active] && actual_products.present?
  end

  def self.pluck_for_select(except=[])
    options = Rails.cache.fetch "VirtualProduct/pluck_for_select/#{cache_key}" do
      Product.where("products.parent_id IS NULL").where("products.is_virtual" => false).pluck(:sku, :id)
    end
    options.select { |ops| !except.include?(ops[1]) }
  end

end