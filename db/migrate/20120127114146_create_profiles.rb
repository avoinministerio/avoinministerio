class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :citizen_id
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
