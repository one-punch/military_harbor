module ProductsHelper
  def varirant_property_name variant
    variant.properties.map {|property| "#{property.key}:#{property.value}"}.join(' ')
  end

  def varirants_selector product
    return if product.is_virtual? || product.is_master? && !product.has_variant?
    html = capture { label_tag 'variants' }
    html << capture do
      if product.is_sku?
        variants = product.parent.sorted_variants
        options = options_for_select(variants.map {|x| ["#{varirant_property_name(x)}", x.id, {data: {variant: product_path(x.id, x.name)}}]}, product.id)
        select_tag('variants', options, class: 'form-control')
      else
        variants = product.sorted_variants
        options = options_for_select(variants.map {|x| ["#{varirant_property_name(x)}", x.id, {data: {variant: product_path(x.id, x.name)}}]})
        select_tag('variants', options, class: 'form-control', include_blank: 'Select')
      end
    end
  end

  def product_breadcrumb product
    content_tag(:ol, class: 'breadcrumb') do
      concat(content_tag(:li) do
        link_to 'Home', root_path
      end)
      product.category.path.map do |category|
        concat(content_tag(:li) do
          link_to category.name, products_path(category_id: category.id)
        end)
      end
      concat(content_tag(:li, product.name, class: 'active'))
    end
  end
end
