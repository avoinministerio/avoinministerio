class MakeTagSuggestionPolymorphic < ActiveRecord::Migration
  def up
    citizen_ids = TagSuggestion.select("citizen_id").collect(&:citizen_id)

    remove_column :tag_suggestions, :citizen_id
    add_column :tag_suggestions, :user_id, :integer
    add_column :tag_suggestions, :user_type, :string, :default => 'Citizen'
    add_index :tag_suggestions, :user_id, :name => 'ts_user_id'

    TagSuggestion.reset_column_information
    TagSuggestion.all.each_with_index { |ts, index| ts.update_attribute(:user_id, citizen_ids[index]) }
  end

  def down
    user_ids = TagSuggestion.select("user_id").where(:user_type => 'Citizen').collect(&:user_id)

    add_column :tag_suggestions, :citizen_id, :integer
    remove_column :tag_suggestions, :user_id
    remove_column :tag_suggestions, :user_type

    TagSuggestion.reset_column_information
    TagSuggestion.all.each_with_index { |ts, index| ts.update_attribute(:citizen_id, user_ids[index]) }
  end
end
