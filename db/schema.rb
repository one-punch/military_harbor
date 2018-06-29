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

ActiveRecord::Schema.define(version: 20180625233330) do

  create_table "attachments", force: :cascade do |t|
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

  create_table "cart_items", force: :cascade do |t|
    t.integer "quantity", default: 1
    t.integer "product_id"
    t.integer "cart_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.integer "ancestry_depth"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "order_items", force: :cascade do |t|
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.integer "quantity"
    t.integer "product_id"
    t.integer "order_id"
  end

  create_table "orders", force: :cascade do |t|
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
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_details", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
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
  end

  create_table "properties", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.string "key"
    t.string "value"
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_groups", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shippers", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
