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

ActiveRecord::Schema.define(version: 20131221104637) do

  create_table "media", force: true do |t|
    t.string   "app"
    t.string   "context"
    t.string   "locale"
    t.string   "tags"
    t.string   "content_type"
    t.string   "url"
    t.string   "name"
    t.integer  "lock_version", default: 0,  null: false
    t.integer  "created_by",   default: 0,  null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "bytesize",     default: 0,  null: false
    t.integer  "updated_by",   default: 0,  null: false
    t.datetime "delete_at"
    t.string   "email"
    t.string   "file_name",    default: "", null: false
    t.string   "usage",        default: "", null: false
  end

  add_index "media", ["app", "context", "name", "locale", "content_type"], name: "main_index", unique: true
  add_index "media", ["app", "locale"], name: "index_media_on_app_and_locale"
  add_index "media", ["delete_at"], name: "index_media_on_delete_at"
  add_index "media", ["file_name"], name: "index_media_on_file_name"

end
