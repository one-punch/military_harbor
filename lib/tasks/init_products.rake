require 'json'

desc "import classes to DB"
namespace :products do
  task :init => [ :environment ] do
    def init_category
      grades = [{:id=>1, :name=>"一年级"},
         {:id=>2, :name=>"二年级"},
         {:id=>3, :name=>"三年级"},
         {:id=>4, :name=>"四年级"},
         {:id=>5, :name=>"五年级"},
         {:id=>6, :name=>"六年级"},
         {:id=>7, :name=>"初一"},
         {:id=>8, :name=>"初二"},
         {:id=>9, :name=>"初三"},
         {:id=>10, :name=>"高一"},
         {:id=>11, :name=>"高二"},
         {:id=>12, :name=>"高三"}]
      grades.each do |g|
        Category.where(id: g[:id], name: g[:name]).first_or_create
      end

      subjects = Subject.all.to_a
      Category.where(id: grades.map{|g| g[:id]}).find_each do |c|
        subjects.each do |sub|
          c.children.where(name: sub.name).first_or_create(ancestry_depth: 1)
        end
      end

      Course.preload(:grade, :subject, :materials).find_each do |cour|
        # cour.grade # 第一层
        # cour.subject #第二层
        subject = Category.where(ancestry: cour.grade.id, ancestry_depth: 1, name: cour.subject.name).take
        course = subject.children.where(name: cour.name).first_or_create(ancestry_depth: 2)
        cour.materials.preload(:papers).order("materials.number").each do |mat|
          material = course.children.where(name: mat.name).first_or_create(ancestry_depth: 3, position: mat.number)
          mat.papers.each do |paper|
            product = init_product(paper, material)
            init_variant(paper, material, product)
            if product.save
            else
              @logger.error(product.errors.full_messages.join("; "))
            end
          end
        end
      end
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

    def init_virtual_product
      Category.where(ancestry_depth: 1).find_each do |c|
        name = "#{c.parent.name} #{c.name} 套餐"
        virtual_product = VirtualProduct.create(name: name, sku: SecureRandom.hex, price: 99, category_id: c.id)
        virtual_product.properties.create(key: :subscribe, value: 100)
        virtual_product.properties.create(key: :download, value: false)
        Product.joins(:category).where("categories.ancestry LIKE ?" => "#{c.parent.id}/#{c.id}/%", "categories.ancestry_depth" => 3).find_each do |product|
          virtual_product.virtual_product_actual_products.where(actual_product_id: product.id).first_or_create
        end
      end
    end

    log_file = File.open("#{Rails.root}/log/init_products.log", 'a')
    @logger = Logger.new log_file
    init_category
    init_virtual_product
  end

end





