class AddLockedAtToCitizens < ActiveRecord::Migration
  def change
    add_column :citizens, :locked_at, :datetime, default: nil
  end
end
