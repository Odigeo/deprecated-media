class FixIndex < ActiveRecord::Migration
  
  def up
    remove_index "media", ["app", "context", "name", "locale"]
    add_index    "media", ["app", "context", "name", "locale"], :unique => true
  end

  def down
    remove_index "media", ["app", "context", "name", "locale"]
    add_index    "media", ["app", "context", "name", "locale"], :unique => false
  end
  
end
