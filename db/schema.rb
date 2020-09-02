# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200902074241) do

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.string "file", null: false
    t.string "file_name"
    t.integer "file_size"
    t.string "file_type"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "quantity", default: 1
    t.integer "product_id"
    t.integer "cart_id"
  end

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.boolean "active", default: true
    t.integer "ancestry_depth"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.boolean "is_leaf", default: false
    t.index ["active"], name: "index_categories_on_active"
    t.index ["ancestry_depth"], name: "index_categories_on_ancestry_depth"
    t.index ["is_leaf"], name: "index_categories_on_is_leaf"
  end

  create_table "courses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "proto_id", null: false
    t.string "name"
    t.integer "subject_id", null: false
    t.integer "grade_id", null: false
    t.json "attrs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "grade_group_id", null: false
    t.string "type_name", default: "教材"
    t.string "proto_parent_id"
    t.index ["grade_id"], name: "index_courses_on_grade_id"
    t.index ["proto_id"], name: "index_courses_on_proto_id", unique: true
    t.index ["subject_id"], name: "index_courses_on_subject_id"
    t.index ["type_name"], name: "index_courses_on_type_name"
  end

  create_table "exam_paper_elements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "proto_id", null: false
    t.string "proto_paper_id", null: false
    t.text "content"
    t.integer "contentType"
    t.string "axis"
    t.string "number"
    t.string "remark"
    t.boolean "deleted"
    t.string "blank"
    t.string "queTypeName"
    t.text "hideMainIdList"
    t.text "hideQueIdList"
    t.text "question", limit: 16777215
    t.string "contentTypeCode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "proto_question_id"
    t.index ["proto_id"], name: "index_exam_paper_elements_on_proto_id"
    t.index ["proto_paper_id"], name: "index_exam_paper_elements_on_proto_paper_id"
    t.index ["proto_question_id"], name: "index_exam_paper_elements_on_proto_question_id"
  end

  create_table "grades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.index ["group_id"], name: "index_grades_on_group_id"
  end

  create_table "materials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "proto_id", null: false
    t.string "name"
    t.integer "number", default: 0
    t.string "proto_course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "attrs"
    t.string "proto_parent_id"
    t.index ["proto_course_id"], name: "index_materials_on_proto_course_id"
    t.index ["proto_id"], name: "index_materials_on_proto_id", unique: true
  end

  create_table "order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.integer "quantity"
    t.integer "product_id"
    t.integer "order_id"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "street"
    t.string "zip"
    t.integer "pay"
    t.string "pay_number"
    t.integer "status"
    t.integer "shipper_id"
    t.string "shipping_number"
    t.decimal "subtotal", precision: 8, scale: 2, default: "0.0"
    t.decimal "shipping_total", precision: 8, scale: 2, default: "0.0"
    t.decimal "actual_shipping_cost", precision: 8, scale: 2, default: "0.0"
    t.decimal "total", precision: 8, scale: 2, default: "0.0"
    t.decimal "profit", precision: 8, scale: 2, default: "0.0"
    t.decimal "weight", precision: 8, scale: 2, default: "0.0"
    t.decimal "actual_weight", precision: 8, scale: 2, default: "0.0"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "qrcode_url"
    t.datetime "expired_at"
    t.string "extension"
  end

  create_table "papers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "proto_id", null: false
    t.string "name"
    t.string "proto_material_id", null: false
    t.text "student"
    t.text "teacher"
    t.string "type_name"
    t.integer "number"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "student_file"
    t.string "teacher_file"
    t.index ["proto_id"], name: "index_papers_on_proto_id", unique: true
    t.index ["proto_material_id"], name: "index_papers_on_proto_material_id"
    t.index ["type_name"], name: "index_papers_on_type_name"
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "product_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "sku"
    t.text "description"
    t.boolean "active", default: true
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.decimal "purchase_price", precision: 8, scale: 2, default: "0.0"
    t.decimal "weight", precision: 8, scale: 2, default: "0.0"
    t.integer "category_id"
    t.integer "parent_id"
    t.integer "product_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_virtual", default: false
    t.integer "paper_id"
    t.index ["active"], name: "index_products_on_active"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["is_virtual"], name: "index_products_on_is_virtual"
    t.index ["paper_id"], name: "index_products_on_paper_id"
    t.index ["parent_id"], name: "index_products_on_parent_id"
  end

  create_table "properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id", null: false
    t.integer "key", default: 0
    t.string "value"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "proto_id", null: false
    t.string "proto_parent_id"
    t.string "proto_root_id"
    t.integer "subject_id", default: 0, null: false
    t.integer "grade_group_id", default: 1, null: false
    t.integer "logic_ques_type_id"
    t.integer "difficulty", default: 0
    t.string "written_ques_type_id"
    t.string "written_ques_type_name"
    t.text "content"
    t.text "answer"
    t.text "analysis"
    t.boolean "deleted", default: false, null: false
    t.text "organization_list"
    t.string "keyword"
    t.string "video_url"
    t.text "voice_text"
    t.text "translated_text"
    t.text "que_desc"
    t.string "que_preview_url"
    t.string "order_id"
    t.boolean "is_analysis", default: false
    t.integer "answer_type"
    t.boolean "is_decidable", default: true
    t.text "blank_answer"
    t.text "bx_answer"
    t.integer "degree"
    t.text "option_analysis_list"
    t.text "option_difficulty_list"
    t.text "answer_option_list"
    t.text "question_source_list"
    t.text "exam_option_list"
    t.text "option_exam_option_list"
    t.text "que_source"
    t.boolean "duplicate_flag", default: false
    t.boolean "deprecated", default: false
    t.boolean "is_have_analysis", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number", default: 0
    t.index ["number"], name: "index_questions_on_number"
    t.index ["proto_id"], name: "index_questions_on_proto_id", unique: true
    t.index ["proto_parent_id"], name: "index_questions_on_proto_parent_id"
    t.index ["proto_root_id"], name: "index_questions_on_proto_root_id"
    t.index ["subject_id"], name: "index_questions_on_subject_id"
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "key", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "shippers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_favorites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "user_id", null: false
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "item_type"], name: "index_user_favorites_on_item_id_and_item_type"
    t.index ["user_id"], name: "index_user_favorites_on_user_id"
  end

  create_table "user_paper_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false
    t.integer "paper_id", null: false
    t.date "expired_at"
    t.boolean "allow_download", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "paper_id"], name: "index_user_paper_records_on_user_id_and_paper_id", unique: true
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.integer "favorite_count", default: 24
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "virtual_product_actual_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "virtual_product_id", null: false
    t.integer "actual_product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["virtual_product_id", "actual_product_id"], name: "index_virtual_actual_products_on_virtual_and_actual_id", unique: true
  end

end
