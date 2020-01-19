class SyncPaperToProductsJob < ApplicationJob
  queue_as :default

  def perform
    log_file = File.open("#{Rails.root}/log/sync_paper_to_products_job.log", 'a')
    @logger = Logger.new log_file

    @papers = Paper.find_by_sql %Q{
      SELECT DISTINCT papers.* from papers
      LEFT JOIN products ON papers.id = products.paper_id
      WHERE products.id IS NULL AND papers.name IS NOT NULL
    }
    @mats = {}
    @cours = {}

    @papers.each do |paper|
      ancestry_depth = 1
      if @mats[paper.proto_material_id].present?
        mat = @mats[paper.proto_material_id]
      else
        mat = paper.material
        @mats[paper.proto_material_id] = mat
      end

      if @cours[mat.proto_course_id].present?
        cour = @cours[mat.proto_course_id]
      else
        cour = mat.course
        @cours[mat.proto_course_id] = cour
      end

      ancestry_depth = 1
      subject = Category.where(ancestry: cour.grade.id, ancestry_depth: ancestry_depth, name: cour.subject.name).take
      course = course_to_category(subject, cour)
      material = material_to_category(course, mat)
      material.update_attributes(is_leaf: true)

      product = init_product(paper, material)
      init_variant(paper, material, product)
      if product.save
      else
        @logger.error(product.errors.full_messages.join("; "))
      end
    end
  end

  def course_to_category(parent, cour)
    if cour.proto_parent_id.present?
      if @cours[cour.proto_parent_id].present?
        cour_parent = @cours[cour.proto_parent_id]
      else
        cour_parent = cour.parent
        @cours[cour.proto_parent_id] = cour_parent
      end
      _parent = course_to_category(parent, cour_parent)
    else
      _parent = parent
    end
    _parent.children.where(name: cour.name).first_or_create(ancestry_depth: _parent.ancestry_depth + 1, is_leaf: false)
  end

  def material_to_category(parent, mat)
    if mat.parent.present?
      if @mats[mat.proto_parent_id].present?
        mat_parent = @mats[mat.proto_parent_id]
      else
        mat_parent = mat.parent
        @mats[mat.proto_parent_id] = mat_parent
      end
      _parent = material_to_category(parent, mat_parent)
    else
      _parent = parent
    end
    _parent.children.where(name: mat.name).first_or_create(ancestry_depth: _parent.ancestry_depth + 1, position: mat.number, is_leaf: false)
  end


  def init_product(paper, category)
    Product.create(name: paper.name, sku: SecureRandom.hex, price: 1.99, category_id: category.id, paper_id: paper.id)
  end

  def init_variant(paper, category, parent)
    # 生成两个 variant
    # 一个包含订阅 property，一个下载property
    # 关联回master product
    subscription = parent.variants.build(name: paper.name, sku: SecureRandom.hex, price: 1.99, category_id: category.id, paper_id: paper.id)
    download = parent.variants.build(name: paper.name, sku: SecureRandom.hex, price: 1.99, category_id: category.id, paper_id: paper.id)
    subscription.properties.build(key: :subscribe, value: 100)
    download.properties.build(key: :download, value: false)
  end

end