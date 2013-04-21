class RemoveFkInTestEnv < ActiveRecord::Migration
  def up
    if ENV['RAILS_ENV'] == 'test'
      remove_foreign_key "receipts", :name => "receipts_on_notification_id"
    	remove_foreign_key "notifications", :name => "notifications_on_conversation_id"
    end
  end

  def down
    if ENV['RAILS_ENV'] == 'test'
      add_foreign_key "receipts", :name => "receipts_on_notification_id"
    	add_foreign_key "notifications", :name => "notifications_on_conversation_id"
    end
  end
end
