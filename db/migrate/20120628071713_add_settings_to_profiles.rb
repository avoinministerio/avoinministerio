class AddSettingsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :receive_newsletter, :boolean
    add_column :profiles, :receive_other_announcements, :boolean
    add_column :profiles, :receive_weekletter, :boolean
    add_column :profiles, :first_names, :string
    add_column :profiles, :accept_science, :boolean
    add_column :profiles, :accept_terms_of_use, :boolean
  end
end
