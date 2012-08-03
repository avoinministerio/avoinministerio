class AddAnonymizedToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :anonymized, :boolean
  end
end
