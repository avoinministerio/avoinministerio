class Citizens::RegistrationsController < Devise::RegistrationsController
  def new
    super
    KM.identify(current_citizen)
    KM.push("record", "View Sign up")
    Rails.logger.info "########### View Sign up"
  end

  def create
    super
    if resource.valid? && resource.persisted?
      KM.identify(current_citizen)
      KM.push("record", "Signed up")
      Rails.logger.info "########### Signed up"
    end
  end

  def destroy
    super
    KM.identify(current_citizen)
    KM.push("record", "Signed down")
    Rails.logger.info "########### Signed down"
  end
end
