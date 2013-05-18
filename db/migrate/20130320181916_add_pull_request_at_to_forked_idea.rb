class AddPullRequestAtToForkedIdea < ActiveRecord::Migration
  def change
    add_column :forked_ideas, :pull_request_at, :datetime
    add_column :forked_ideas, :is_closed, :boolean, :default => false

    add_index :forked_ideas, :pull_request_at, :name => 'inx_frkd_ideas_pr_at'
  end
end
