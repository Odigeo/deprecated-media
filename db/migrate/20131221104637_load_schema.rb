class LoadSchema < ActiveRecord::Migration

  create_table "media", :force => true do |t|
    t.string   "app"
    t.string   "context"
    t.string   "locale"
    t.string   "tags"
    t.string   "content_type"
    t.string   "url"
    t.string   "name"
    t.integer  "lock_version", :default => 0,  :null => false
    t.integer  "created_by",   :default => 0,  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "bytesize",     :default => 0,  :null => false
    t.integer  "updated_by",   :default => 0,  :null => false
    t.datetime "delete_at"
    t.string   "email"
    t.string   "file_name",    :default => "", :null => false
    t.string   "usage",        :default => "", :null => false
  end

  add_index "media", ["app", "context", "name", "locale", "content_type"], :name => "main_index", :unique => true
  add_index "media", ["app", "locale"], :name => "index_media_on_app_and_locale"
  add_index "media", ["delete_at"], :name => "index_media_on_delete_at"
  add_index "media", ["file_name"], :name => "index_media_on_file_name"

end
