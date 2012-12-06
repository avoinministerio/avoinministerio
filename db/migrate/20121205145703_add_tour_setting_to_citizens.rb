class AddTourSettingToCitizens < ActiveRecord::Migration
  def change
    add_column :citizens, :tour_setting, :text
  end
end
