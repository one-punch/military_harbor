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

  def link_to_add_fields(name, f, association, html_options={})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("admin/products/#{association.to_s.singularize}_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", html_options)
  end

  def link_to_remove_fields(name, f, html_options={})
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", html_options)
  end

  def link_to_function(name, function, html_options={})
    onclick = "#{"#{html_options[:onclick]}; " if html_options[:onclick]}#{function}; return false;"
    href = html_options[:href] || '#'
    content_tag(:a, name, html_options.merge(:href => href, :onclick => onclick))
  end


  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
      format.any  { head 404 }
    end
  end
end
