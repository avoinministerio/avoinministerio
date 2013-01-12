class IdeaSweeper < ActionController::Caching::Sweeper
  observe Idea
  
  def after_save(idea)
    Rails.cache.clear
  end
end