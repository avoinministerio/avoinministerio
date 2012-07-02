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
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance