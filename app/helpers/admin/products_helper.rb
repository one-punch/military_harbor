module Admin::ProductsHelper

  %i(name sku price purchase_price category_id).each do |field|
    define_method "product_#{field}" do |product|
      product = product.parent if product.is_sku?
      product.send(field)
    end
  end

  def disabled_status product
    product.is_sku? ? true : false
  end

  def varirant_property_name variant
    variant.properties.map {|property| "#{property.key}:#{property.value}"}.join(' ')
  end

  def varirants_selector product
    return if product.is_master? && !product.has_variant?
    html = capture { label_tag 'variants' }
    html << capture do
      if product.is_sku?
        variants = product.parent.variants
        options = options_for_select(variants.map {|x| ["#{varirant_property_name(x)}", x.id]}, product.id)
        select_tag('variants', options, class: 'form-control')
      else
        variants = product.variants
        options = options_for_select(variants.map {|x| ["#{varirant_property_name(x)}", x.id]})
        select_tag('variants', options, class: 'form-control', include_blank: 'All')
      end
    end
  end

  def product_images product
    if product.is_sku?
      product.images.present? ? product.images : product.parent.images
    else
      product.images
    end
  end
end
