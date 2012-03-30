class CitizenSessionsController < Devise::SessionsController

  def new
    KM.identify(current_citizen)
    KM.push("record", "View Sign in")
    logger.info "########### View Sign in"
    super
  end

  def create
  	KM.identify(current_citizen)
   	KM.push("record", "Signed in")
   	logger.info "########### Signed in"
#    redirect_to :back
  	super
  end

  def destroy
  	KM.identify(current_citizen)
   	KM.push("record", "Signed out")
   	logger.info "########### Signed out"
  	super
  end

end
