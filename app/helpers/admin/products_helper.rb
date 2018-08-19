module Admin::ProductsHelper

  %i(name sku price purchase_price weight category_id product_detail_id).each do |field|
    define_method "product_#{field}" do |product|
      product = product.parent if product.is_sku? && product.new_record?
      product.send(field)
    end
  end

  def disabled_status product
    product.is_sku? ? true : false
  end
end
