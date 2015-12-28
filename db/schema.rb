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

ActiveRecord::Schema.define(version: 20140614175237) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",        limit: 50,                null: false
    t.text     "content",      limit: 65535,             null: false
    t.integer  "user_id",      limit: 4,                 null: false
    t.integer  "shared_type",  limit: 1,     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "lock_version", limit: 4,     default: 0
  end

  add_index "articles", ["title"], name: "index_articles_on_title", unique: true, using: :btree

  create_table "articles_tags", id: false, force: :cascade do |t|
    t.integer  "article_id", limit: 4, null: false
    t.integer  "tag_id",     limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles_tags", ["article_id", "tag_id"], name: "index_articles_tags_on_article_id_and_tag_id", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",         limit: 30,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version", limit: 4,  default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login_id",            limit: 30,  default: "", null: false
    t.string   "encrypted_password",  limit: 255, default: "", null: false
    t.string   "email",               limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",  limit: 255
    t.string   "last_sign_in_ip",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "lock_version",        limit: 4,   default: 0
  end

  add_index "users", ["login_id"], name: "index_users_on_login_id", unique: true, using: :btree

end
