class DeviseCreateAdministrators < ActiveRecord::Migration
  def change
    create_table(:administrators) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.string :email
      t.string :password
      t.timestamps
    end

    add_index :administrators, :email,                :unique => true
    add_index :administrators, :reset_password_token, :unique => true
  end

end
