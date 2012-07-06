class DeviseCreateCitizens < ActiveRecord::Migration
  def change
    create_table(:citizens) do |t|
      # ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      # ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # ## Rememberable
      t.datetime :remember_created_at

      # ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    add_index :citizens, :email,                :unique => true
    add_index :citizens, :reset_password_token, :unique => true
    # add_index :citizens, :confirmation_token,   :unique => true
    # add_index :citizens, :unlock_token,         :unique => true
    # add_index :citizens, :authentication_token, :unique => true
  end

end
