class AddMoreProperties < ActiveRecord::Migration
  
  def change
    add_column :media, :bytesize,  :integer,  :null => false, :default => 0
    add_column :media, :updated_by, :string,  :null => false, :default => ''
  end
  
end
