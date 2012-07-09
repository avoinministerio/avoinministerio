module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

  def signup_page
    new_citizen_registration_fi_path
  end

  def login_page
    new_citizen_session_fi_path
  end

  def idea_page(idea_id)
    idea_fi_path(idea_id)
  end

  def signature_idea_introduction(idea_id)
    signature_idea_introduction_fi_path(idea_id)
  end

end

RSpec.configuration.include NavigationHelpers, :type => :acceptance