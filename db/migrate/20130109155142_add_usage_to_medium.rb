class AddUsageToMedium < ActiveRecord::Migration

  def change
    add_column :media, :usage, :string, null: false, default: ""
  end

end
