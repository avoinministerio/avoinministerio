class CreateForkedIdeas < ActiveRecord::Migration
  def change
    create_table :forked_ideas do |t|
      t.integer :translated_idea_id
      t.integer :author_id
      t.string :title
      t.text :body
      t.text :summary

      t.timestamps
    end
  end
end
