class CreateTranslatedIdeas < ActiveRecord::Migration
  def change
    create_table :translated_ideas do |t|
      t.integer :idea_id
      t.integer :author_id
      t.string :language
      t.string :title
      t.text :body
      t.text :summary

      t.timestamps
    end
  end
end
