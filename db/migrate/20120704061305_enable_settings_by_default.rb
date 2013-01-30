class EnableSettingsByDefault < ActiveRecord::Migration
  def up
    change_column_default(:profiles, :receive_newsletter, true)
    change_column_default(:profiles, :receive_other_announcements, true)
    change_column_default(:profiles, :receive_weekletter, true)
    change_column_default(:profiles, :accept_science, true)
    change_column_default(:profiles, :accept_terms_of_use, true)
    
    Profile.all.each do |profile|
      # We have to make the profile pass validation,
      # or else it won't be saved
      if profile.first_names.nil?
        profile.first_names = profile.first_name
      end
      profile.receive_newsletter = true
      profile.receive_other_announcements = true
      profile.receive_weekletter = true
      profile.accept_science = true
      profile.accept_terms_of_use = true
      profile.save
    end
  end

  def down
    change_column_default(:profiles, :receive_newsletter, nil)
    change_column_default(:profiles, :receive_other_announcements, nil)
    change_column_default(:profiles, :receive_weekletter, nil)
    change_column_default(:profiles, :accept_science, nil)
    change_column_default(:profiles, :accept_terms_of_use, nil)
    
    Profile.all.each do |profile|
      profile.receive_newsletter = nil
      profile.receive_other_announcements = nil
      profile.receive_weekletter = nil
      profile.accept_science = nil
      profile.accept_terms_of_use = nil
      profile.save
    end
  end
end
