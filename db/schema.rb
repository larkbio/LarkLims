# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140912093739) do

  create_table "orders", force: true do |t|
    t.datetime "order_date"
    t.string   "catalog_number"
    t.float    "price"
    t.integer  "quantity"
    t.string   "units"
    t.string   "department"
    t.text     "comment"
    t.string   "url"
    t.string   "ordered_from"
    t.integer  "status"
    t.datetime "arrival_date"
    t.string   "place"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "orders", ["product_id"], name: "index_orders_on_product_id"

  create_table "product_params", force: true do |t|
    t.string   "key"
    t.string   "name"
    t.string   "paramtype"
    t.string   "description"
    t.string   "constraint"
    t.boolean  "mandatory"
    t.text     "value"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.boolean  "is_product",  default: true
  end

  add_index "product_params", ["key", "product_id", "order_id"], name: "index_product_params", unique: true
  add_index "product_params", ["order_id"], name: "index_product_params_on_order_id"
  add_index "product_params", ["product_id"], name: "index_product_params_on_product_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["name"], name: "index_product_on_name", unique: true

  create_table "users", force: true do |t|
    t.string   "email",            null: false
    t.string   "crypted_password", null: false
    t.string   "salt",             null: false
    t.string   "name",             null: false
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
