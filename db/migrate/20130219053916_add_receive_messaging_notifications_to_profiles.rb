class AddReceiveMessagingNotificationsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :receive_messaging_notifications, :boolean, default: true
  end
end
