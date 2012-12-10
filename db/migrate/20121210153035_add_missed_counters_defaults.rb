class AddMissedCountersDefaults < ActiveRecord::Migration
  def change
    change_column :ideas, :additional_signatures_count, :integer, default: 0
    change_column :ideas, :target_count, :integer, default: 0
  end
end
