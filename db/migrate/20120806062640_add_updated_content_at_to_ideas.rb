class AddUpdatedContentAtToIdeas < ActiveRecord::Migration
  def up
    add_column :ideas, :updated_content_at, :datetime
    Idea.all.each do |idea|
      idea.updated_content_at = idea.updated_at
      idea.save
    end
  end
  
  def down
    remove_column :ideas, :updated_content_at
  end
end
