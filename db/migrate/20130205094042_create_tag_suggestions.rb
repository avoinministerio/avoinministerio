class CreateTagSuggestions < ActiveRecord::Migration
  def change
    create_table :tag_suggestions do |t|
      t.belongs_to :tag
      t.belongs_to :idea
      t.belongs_to :citizen

      t.timestamps
    end
    add_index :tag_suggestions, :tag_id
    add_index :tag_suggestions, :idea_id
    add_index :tag_suggestions, :citizen_id
  end
end
