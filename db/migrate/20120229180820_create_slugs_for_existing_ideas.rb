class CreateSlugsForExistingIdeas < ActiveRecord::Migration
  def up
    ideas = Idea.all.each do |idea|
      idea.save!
    end
    puts "Updated slugs for #{ideas.size} ideas."
  end

  def down
  end
end
