class UpdateIndicesForMedia < ActiveRecord::Migration
  
  def up
    remove_index :media, [:app, :context, :name, :locale]
    add_index :media, [:app, :context, :name, :locale, :mime_type], 
                      name: 'main_index', unique: true
    add_index :media, :file_name
  end

  def down
    add_index :media, [:app, :context, :name, :locale], unique: true
    remove_index :media, name: 'main_index'
    remove_index :media, :file_name
  end
  
end
