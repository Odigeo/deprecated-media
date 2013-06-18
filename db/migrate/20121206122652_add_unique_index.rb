class AddUniqueIndex < ActiveRecord::Migration
  
  def up
    remove_index :media, [:app, :context, :locale, :name]
    add_index :media, [:app, :context, :locale, :name], :unique => true
  end

  def down
    remove_index :media, [:app, :context, :locale, :name]
    add_index :media, [:app, :context, :locale, :name], :unique => false
  end
  
end
