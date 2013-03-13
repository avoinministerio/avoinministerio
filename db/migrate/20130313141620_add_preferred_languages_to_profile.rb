class AddPreferredLanguagesToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :preferred_language, :string
  end
end
