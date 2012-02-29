class AddPublishingStateToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :publish_state, :string, default: "unpublished"
  end
end
