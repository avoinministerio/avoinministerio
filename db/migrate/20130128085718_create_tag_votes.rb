class CreateTagVotes < ActiveRecord::Migration
  def change
    create_table :tag_votes do |t|
      t.belongs_to :tag
      t.belongs_to :idea
      t.belongs_to :citizen

      t.string :voted

      t.timestamps
    end
    add_index :tag_votes, :tag_id
    add_index :tag_votes, :idea_id
    add_index :tag_votes, :citizen_id
  end
end
