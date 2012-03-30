class Citizens::SessionsController < Devise::SessionsController
  def new
    super
    KM.identify(current_citizen)
    KM.push("record", "View log in")
    Rails.logger.info "########### View Sign in"
  end

  def create
    super
    if current_citizen.present?
      KM.identify(current_citizen)
      KM.push("record", "Logged in")
      Rails.logger.info "########### Logged in"
    end
  end

  def destroy
    super
    KM.identify(current_citizen)
    KM.push("record", "Logged out")
    Rails.logger.info "########### Logged out"
  end
end
