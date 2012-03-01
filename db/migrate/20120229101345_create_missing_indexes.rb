class CreateMissingIndexes < ActiveRecord::Migration
  def up
    add_index :comments, :author_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :ideas, :author_id
    add_index :profiles, :citizen_id
  end

  def down
    remove_index :comments, :author_id
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :ideas, :author_id
    remove_index :profiles, :citizen_id
  end
end
