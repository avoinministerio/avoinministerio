class AddCopiedByToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :copier_id, :integer
  end
end
