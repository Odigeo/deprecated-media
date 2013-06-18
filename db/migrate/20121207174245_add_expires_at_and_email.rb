class AddExpiresAtAndEmail < ActiveRecord::Migration
  
  def change
    add_column :media, :delete_at, :datetime, :null => true, :default => nil
    add_column :media, :email, :string
  end
  
end
