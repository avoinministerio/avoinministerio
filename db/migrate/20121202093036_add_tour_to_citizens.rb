class AddTourToCitizens < ActiveRecord::Migration
  def change
	add_column :citizens, :home_tour_ended, :boolean, :default => 0
  	add_column :citizens, :idea_tour_ender, :boolean, :default => 0
  end
end
