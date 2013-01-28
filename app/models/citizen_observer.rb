class CitizenObserver < ActiveRecord::Observer
  def after_create(citizen)
    famous_ideas = Idea.find(:all, :conditions => ["collecting_started='true' and collecting_ended='false' and (state='proposal' OR state='idea')"], :limit => 3, :order => "vote_for_count DESC")
    ideas = Idea.find(:all, :conditions => ["state='proposal' and publish_state='published' and collecting_started='true' and collecting_ended='false'"], :limit => 6)
    ideas.randomize!
    CitizenMailer.welcome_email(citizen, ideas, famous_ideas).deliver
  end
end
