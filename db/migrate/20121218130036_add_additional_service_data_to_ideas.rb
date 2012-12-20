class AddExternalResourcesToIdeas < ActiveRecord::Migration
  def self.up
    add_column :ideas, :additional_service_data, :text
  end

  def self.down
    remove_column :ideas, :additional_service_data
  end

end
