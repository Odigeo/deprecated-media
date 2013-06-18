class RenameMimeTypeToContentType < ActiveRecord::Migration
  
  def up
    rename_column :media, :mime_type, :content_type
  end

  def down
    rename_column :media, :content_type, :mime_type
  end
  
end
