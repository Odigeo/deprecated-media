class AddFileNameToMedia < ActiveRecord::Migration
  def change
    add_column :media, :file_name, :string, null: false, default: ""
  end
end
