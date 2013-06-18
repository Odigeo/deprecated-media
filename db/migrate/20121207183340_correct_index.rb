class CorrectIndex < ActiveRecord::Migration
  
  def up
    remove_index "media", ["app", "context", "locale", "name"]
    add_index    "media", ["app", "context", "name", "locale"]
  end

  def down
    remove_index "media", ["app", "context", "name", "locale"]
    add_index    "media", ["app", "context", "locale", "name"]
  end
  
end
