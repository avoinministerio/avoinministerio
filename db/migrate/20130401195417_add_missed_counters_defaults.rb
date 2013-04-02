class AddMissedCountersDefaults < ActiveRecord::Migration
  def change
    Idea.where('ideas.additional_signatures_count IS NULL OR ideas.target_count IS NULL').find_each { |i|
      i.additional_signatures_count = 0 unless i.additional_signatures_count
      i.target_count = 0 unless i.target_count
      i.save
    }
    change_column :ideas, :additional_signatures_count, :integer, default: 0
    change_column :ideas, :target_count, :integer, default: 0
  end
end
