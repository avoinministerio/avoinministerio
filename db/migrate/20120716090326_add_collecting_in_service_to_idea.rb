class AddCollectingInServiceToIdea < ActiveRecord::Migration
  def up
    add_column :ideas, :collecting_in_service, :boolean
    add_column :ideas, :additional_collecting_service_urls, :string  # using !!! as a separator between multiple urls

    # WARNING!!! BEWARE!!! This update is good only for testing purposes.
    # For production environment one needs to update all these values by hand
    Idea.all.each do |proposal|
      proposal.collecting_in_service = false
      proposal.additional_collecting_service_urls = ""
      proposal.save(validate: false)
    end
  end
  def down
    remove_column :ideas, :collecting_in_service
    remove_column :ideas, :additional_collecting_service_urls
  end
end
