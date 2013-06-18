class AddIndexToMedia < ActiveRecord::Migration
  
  def change
    add_index :media, [:app, :locale]
  end
  
end
