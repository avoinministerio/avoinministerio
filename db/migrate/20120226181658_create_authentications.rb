class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.text :info
      t.text :credentials
      t.text :extra
      t.references :citizen

      t.timestamps
    end

    add_index :authentications, [:provider, :uid], :unique => true
    add_index :authentications, :citizen_id
  end
end
