class AddLanguageToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :language, :string, :default => "fi"
  end
end
