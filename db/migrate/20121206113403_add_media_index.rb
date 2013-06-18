class AddMediaIndex < ActiveRecord::Migration
  
  def up
    add_index :media, [:app, :context, :locale, :name]
  end

  def down
    remove_index :media, [:app, :context, :locale, :name]
  end
  
end
