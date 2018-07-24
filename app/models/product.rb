require 'csv'
class Product < PrimeryProduct

  default_scope {where("products.parent_id IS NULL")}

  has_many :variants, class_name: 'Variant', foreign_key: 'parent_id', dependent: :destroy

  scope :root, -> { where(parent_id: nil) }

  def self.import file
    accessible_attributes = %w(name sku price weight description category_id product_detail_id)
    CSV.foreach(file.path, headers: true) do |row|
      if row["property"]
        product = find_by(sku: row["sku"])
        if product
          property_params = row["property"].split(";").map {|x| ["key", "value"].zip(x.split(":").map(&:strip)).to_h}
          sku = property_params.map{|x| x.values}.sort.to_h.values.unshift(row["sku"]).join('-')
          variant = Variant.find_by(sku: sku) || product.variants.new
          variant.attributes = row.to_hash.slice(*accessible_attributes)
          variant.sku = sku
          variant.save!
          property_params.each do |pro_param|
            variant.properties.create(pro_param)
          end
          row["images"].split(";").each {|x| variant.pictures.create(name: x) } if row["images"].present?
        end
      else
        product = find_by(sku: row["sku"]) || new
        product.attributes = row.to_hash.slice(*accessible_attributes)
        product.save!
        row["images"].split(";").each {|x| product.pictures.create(name: x) } if row["images"].present?
      end
    end
  end

  def has_variant?
    variants.exists?
  end

end
