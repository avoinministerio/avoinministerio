class AddImpressionsCountToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :impressions_count, :integer
  end
end
