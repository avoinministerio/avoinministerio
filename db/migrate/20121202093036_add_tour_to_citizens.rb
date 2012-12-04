class AddTourToCitizens < ActiveRecord::Migration
  def change
	add_column :citizens, :home_tour_ended, :boolean, :default => false
  	add_column :citizens, :idea_tour_ender, :boolean, :default => false
  end
end
