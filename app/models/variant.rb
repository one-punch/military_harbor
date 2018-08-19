class Variant < PrimeryProduct

  default_scope {where("products.parent_id IS NOT NULL")}

  belongs_to :parent, class_name: 'Product', foreign_key: 'parent_id'
  has_many :properties
  accepts_nested_attributes_for :properties, :reject_if => lambda { |a| ![a['key'], a['value']].all? }, :allow_destroy => true

  def property_name
    properties.map { |property| property.value }.join(' ')
  end

  def name
    "#{super} #{property_name}"
  end

  def property_info
    properties.map { |property| "#{property.key}: #{property.value}" }.join(' ')
  end
end
