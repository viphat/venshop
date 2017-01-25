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

ActiveRecord::Schema.define(version: 20170120031631) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "category_name", null: false
  end

  create_table "inventory_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "item_id",       null: false
    t.integer  "order_item_id"
    t.string   "status",        null: false
    t.integer  "quantity",      null: false
    t.index ["item_id"], name: "index_inventory_items_on_item_id", using: :btree
    t.index ["order_item_id"], name: "index_inventory_items_on_order_item_id", using: :btree
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "item_name",                                           null: false
    t.float    "price",                   limit: 24,    default: 0.0, null: false
    t.string   "item_image_file_name"
    t.string   "item_image_content_type"
    t.integer  "item_image_file_size"
    t.datetime "item_image_updated_at"
    t.integer  "category_id"
    t.string   "asin",                    limit: 10
    t.text     "description",             limit: 65535
    t.index ["category_id"], name: "index_items_on_category_id", using: :btree
  end

  create_table "order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "order_id",                           null: false
    t.integer  "item_id",                            null: false
    t.integer  "quantity",               default: 1, null: false
    t.float    "unit_price",  limit: 24,             null: false
    t.float    "total_price", limit: 24,             null: false
    t.index ["item_id"], name: "index_order_items_on_item_id", using: :btree
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "user_id"
    t.string   "status",                                    null: false
    t.float    "subtotal_price",   limit: 24, default: 0.0, null: false
    t.float    "total_price",      limit: 24, default: 0.0, null: false
    t.datetime "ordered_at"
    t.datetime "delivered_at"
    t.string   "shipping_address"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                           default: "",     null: false
    t.string   "email",                          default: "",     null: false
    t.string   "encrypted_password",             default: "",     null: false
    t.integer  "sign_in_count",                  default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "role",                limit: 25, default: "user", null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "address"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "inventory_items", "items"
  add_foreign_key "inventory_items", "order_items"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "users"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
end
