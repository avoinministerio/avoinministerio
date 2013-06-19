class CreatePoliticiansSupports < ActiveRecord::Migration
  def change
    create_table :politicians_supports do |t|
      t.integer :idea_id
      t.integer :citizen_id
      t.string :vote
      t.timestamps
    end
  end
end
