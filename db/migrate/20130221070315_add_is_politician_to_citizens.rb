class AddIsPoliticianToCitizens < ActiveRecord::Migration
  def change
    add_column :citizens, :is_politician, :boolean, default: false
  end
end
