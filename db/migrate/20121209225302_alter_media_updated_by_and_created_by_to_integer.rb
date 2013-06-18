class AlterMediaUpdatedByAndCreatedByToInteger < ActiveRecord::Migration
  
  def up
    change_column :media, :created_by, :integer, :null => false, :default => 0, :limit => nil
    change_column :media, :updated_by, :integer, :null => false, :default => 0, :limit => nil
  end

  def down
    change_column :media, :created_by, :string, :null => false, :default => ''
    change_column :media, :updated_by, :string, :null => false, :default => ''
  end
  
end
