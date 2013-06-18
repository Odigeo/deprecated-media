class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :app
      t.string :context
      t.string :locale
      t.string :tags
      t.string :mime_type
      t.string :url
      t.string :name
      t.integer :lock_version, :default => 0, :null => false
      
      t.string :created_by, :default => '', :null => false
      t.timestamps
    end
  end
end
