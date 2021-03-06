class Variant < PrimeryProduct

  default_scope {where("products.parent_id IS NOT NULL")}

  belongs_to :parent, class_name: 'Product', foreign_key: 'parent_id'
  has_many :properties
  accepts_nested_attributes_for :properties, :reject_if => lambda { |a| ![a['key'], a['value']].all? }, :allow_destroy => true

  SIZE_MAPPING = {
    'S' => -1,
    'M' => 0,
    'L' => 1,
    'X' => 2
  }

  def property_name
    properties.map { |property| property.value }.join(' ')
  end

  def property_info
    properties.map { |property| "#{property.key}: #{property.value}" }.join(' ')
  end

  def property_mapping
    properties.map { |x| [x.key.downcase, x.value] }.to_h
  end

  def sort_value
    @sort_value ||= if size.nil?
                      0
                    elsif size == size.to_i.to_s
                      size.to_i
                    else
                      size.upcase.each_char.map {|x| x.to_i > 0 ? x.to_i : SIZE_MAPPING[x]}.reduce(:*)
                    end
  end

  def size
    property_mapping['size']
  end
end
