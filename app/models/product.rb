require 'csv'
class Product < PrimeryProduct

  default_scope {where("products.parent_id IS NULL")}

  has_many :variants, class_name: 'Variant', foreign_key: 'parent_id', dependent: :destroy

  scope :root, -> { where(parent_id: nil) }

  ACCESSIBLE_FILEDS = %w(name sku price weight description category_id product_detail_id)
  MULTI_FILEDS = %w(properties pictures)

  def self.import file
    CSV.foreach(file.path, headers: true) do |row|
      if row["properties"].present?
        product = find_by(sku: row["sku"])
        variant = Variant.find_by(sku: row["sku"]) || (product ? product.variants.new : nil)
        if variant.present?
          property_params = row["properties"].split(";").map {|x| ["key", "value"].zip(x.split(":").map(&:strip)).to_h}
          sku = row['sku'] == variant.parent.sku ? property_params.map{|x| x.values}.sort.to_h.values.unshift(row["sku"]).join('-') : row['sku']
          variant.attributes = row.to_hash.slice(*ACCESSIBLE_FILEDS).map { |k,v| [k,v.to_s.strip] }.to_h
          variant.sku = sku
          variant.save!
          property_params.each do |pro_param|
            variant.properties.create(pro_param)
          end
          row["images"].split(";").each {|x| variant.pictures.create(name: x.strip) } if row["images"].present?
        end
      else
        product = find_by(sku: row["sku"]) || new
        product.attributes = row.to_hash.slice(*ACCESSIBLE_FILEDS).map { |k,v| [k, v.to_s.strip] }.to_h
        product.save!
        row["images"].split(";").each {|x| product.pictures.create(name: x.strip) } if row["images"].present?
      end
    end
  end

  def self.export options = {}
    headers = ACCESSIBLE_FILEDS + %w(properties images)
    CSV.generate(options) do |csv|
      csv << headers
      all.each do |product|
        csv << export_product(product)
        if product.has_variant?
          product.variants.each do |variant|
            csv << export_product(variant)
          end
        end
      end
    end
  end

  def self.export_product product
    row = product.attributes.values_at(*ACCESSIBLE_FILEDS)

    MULTI_FILEDS.each do |field|
      row << if product.respond_to?(field)
               item = product.send(field)
               if item.present?
                 case field
                 when 'properties'
                   product.send(field).map {|x| "#{x.key}:#{x.value}" }.join(";")
                 else
                   product.send(field).map(&:name).join(";")
                 end
               end
      else
        ''
      end
    end
    row
  end

  def self.pluck_for_select
    Rails.cache.fetch "product/pluck_for_select/#{select(:id, :updated_at).order("updated_at DESC").first&.updated_at.to_i}" do
      unscoped.where("is_virtual = true OR parent_id IS NOT NULL").pluck(:name, :id)
    end
  end

  def has_variant?
    variants.exists?
  end

  def actived_variants
    variants.where(active: true)
  end

  def sorted_variants
    actived_variants.sort_by { |variant| variant.sort_value }
  end

end
