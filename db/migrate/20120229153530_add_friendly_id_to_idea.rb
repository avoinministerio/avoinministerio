class AddFriendlyIdToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :slug, :string
    add_index :ideas, :slug, unique: true
  end
end
