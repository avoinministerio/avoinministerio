class AddSignatureCollectingToIdea < ActiveRecord::Migration
  def up
    add_column :ideas, :collecting_started, :boolean
    add_column :ideas, :collecting_ended, :boolean
    add_column :ideas, :collecting_start_date, :date
    add_column :ideas, :collecting_end_date, :date
    add_column :ideas, :additional_signatures_count, :integer
    add_column :ideas, :additional_signatures_count_date, :date
    add_column :ideas, :target_count, :integer

    # WARNING!!! BEWARE!!! This update is good only for testing purposes.
    # For production environment one needs to update all these values by hand
    Idea.where(state: "proposal").each do |proposal|
      proposal.collecting_started = true
      proposal.collecting_ended = false
      proposal.collecting_start_date = Date.today
      proposal.collecting_end_date = Date.today + 180
      proposal.additional_signatures_count = 0
      proposal.additional_signatures_count_date = Date.today
      proposal.target_count = 51_500
      proposal.save(validate: false)
    end
  end
  def down
    remove_column :ideas, :collecting_started, :boolean
    remove_column :ideas, :collecting_ended, :boolean
    remove_column :ideas, :collecting_start_date, :date
    remove_column :ideas, :collecting_end_date, :date
    remove_column :ideas, :additional_signatures_count, :integer
    remove_column :ideas, :additional_signatures_count_date, :date
    remove_column :ideas, :target_count, :integer
  end
end
