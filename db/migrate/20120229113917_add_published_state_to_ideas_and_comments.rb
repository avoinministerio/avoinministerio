class AddPublishedStateToIdeasAndComments < ActiveRecord::Migration
  def change
    add_column  :ideas,     :publish_state, :string, default: "published"
    add_column  :comments,  :publish_state, :string, default: "published"
    
    add_index   :ideas,     :publish_state
    add_index   :comments,  :publish_state
  end
end
