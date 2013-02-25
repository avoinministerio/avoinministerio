class AddIsLocationToTag < ActiveRecord::Migration
  def change
    add_column :tags, :is_location, :boolean, :default => false
  end
end
