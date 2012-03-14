class CitizenRegistrationsController < Devise::RegistrationsController

  def new
    KM.identify(current_citizen)
    KM.push("record", "View Sign up")
    logger.info "########### View Sign in"
    super
  end

  def create
  	KM.identify(current_citizen)
   	KM.push("record", "Signed up")
   	logger.info "########### Signed up"
#    redirect_to :back
  	super
  end

  def destroy
  	KM.identify(current_citizen)
   	KM.push("record", "Signed down")
   	logger.info "########### Signed down"
  	super
  end

end
