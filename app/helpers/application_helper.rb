module ApplicationHelper

  def full_title(page_title = '')
    base_title = "Military Harbor"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def images_preview(product)
    product.images.map do |img|
      "<img src='#{img.file_url(:thumb)}' class='file-preview-image' alt='Desert' title='Desert'>".html_safe
    end.compact
  end


  def preview_config(product)
    product.images.map do |img|
      {
        width: '120px',
        url: delete_images_admin_product_path(id: product.id, image_id: img.id),
      }
    end.compact
  end

  def nav_active name
    action_name == name ? 'active' : ''
  end
end
