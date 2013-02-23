class AddScoreToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :score, :integer
  end
end
