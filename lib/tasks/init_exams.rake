require 'json'

desc "migrate exam to product"
namespace :exam do
  task :products => [ :environment ] do
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
      subjects = Subject.all.to_a

      Category.where(ancestry_depth: 1).find_each do |c|
        grade = grades.find{|g| g[:name] == c.parent.name }
        subject = subjects.find{|sub| sub.name == c.name }
        next if grade.blank? || subject.blank? || !Paper.joins(material: :course).where("papers.type_name" => "exam", "courses.type_name" => "试卷").where("courses.subject_id" => subject.id, "courses.grade_id" => grade[:id]).exists?
        exam = c.children.where(name: "试卷").first_or_create(ancestry_depth: 2)
        Paper.joins(material: :course).where("papers.type_name" => "exam").where("courses.subject_id" => subject.id, "courses.grade_id" => grade[:id]).find_each do |paper|
            product = init_product(paper, exam)
            if product.valid?
            else
              @logger.error(product.errors.full_messages.join("; "))
            end
        end
      end
    end

    def init_product(paper, category)
      Product.where(paper_id: paper.id, category_id: category.id).first_or_create(name: paper.name, sku: SecureRandom.hex, price: 1.99)
    end

    log_file = File.open("#{Rails.root}/log/init_products.log", 'a')
    @logger = Logger.new log_file
    init_category
  end

end

