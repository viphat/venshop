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

ActiveRecord::Schema.define(version: 20170117072726) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "category_name", null: false
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
    t.text     "description",             limit: 65535,               null: false
    t.index ["category_id"], name: "index_items_on_category_id", using: :btree
  end

  add_foreign_key "items", "categories"
end
