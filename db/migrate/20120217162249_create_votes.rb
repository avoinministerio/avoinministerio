class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :option
      t.references :idea
      t.references :citizen

      t.timestamps
    end
    add_index :votes, :idea_id
    add_index :votes, :citizen_id
  end
end
