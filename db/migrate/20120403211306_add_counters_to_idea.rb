class AddCountersToIdea < ActiveRecord::Migration
  def up
    Idea.transaction do 
      add_column :ideas, :comment_count, :integer
      add_column :ideas, :vote_count, :integer
      add_column :ideas, :vote_for_count, :integer
      add_column :ideas, :vote_against_count, :integer
      add_column :ideas, :vote_proportion, :float
      add_column :ideas, :vote_proportion_away_mid, :float

      # Skipping validation is required for the production data as there are ideas 
      # with body.size < 5 which is validated minimal length
      Idea.skip_callback :validate  
      Idea.all.each do |idea|
        vc = idea.vote_counts
        for_, against_ = vc[1] || 0, vc[0] || 0
        if for_ > 0 or against_ > 0
          proportion = for_.to_f / (for_ + against_)
        else
          proportion = 0.5
        end
        idea.update_attributes!(
          comment_count: idea.comments.count,
          vote_count: for_ + against_,
          vote_for_count: for_,
          vote_against_count: against_,
          vote_proportion: proportion,
          vote_proportion_away_mid: (0.5 - proportion).abs,
        )
      end
    end
  end
  def down
    remove_column :ideas, :comment_count
    remove_column :ideas, :vote_count
    remove_column :ideas, :vote_for_count
    remove_column :ideas, :vote_against_count
    remove_column :ideas, :vote_proportion
    remove_column :ideas, :vote_proportion_away_mid
  end

end
