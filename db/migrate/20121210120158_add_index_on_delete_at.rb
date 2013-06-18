class AddIndexOnDeleteAt < ActiveRecord::Migration
  
  def change
    add_index :media, :delete_at
  end
  
end
