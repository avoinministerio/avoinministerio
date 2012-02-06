class AddSummaryToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :summary, :text
  end
end
