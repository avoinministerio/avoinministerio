class Citizens::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    
    #logger.info "Facebook callback!!"
    omniauth = request.env["omniauth.auth"]
    
    #TODO Handle current_user situation
    @user = Citizen.find_for_facebook_oauth(omniauth)

    if @user.persisted?
     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
     sign_in_and_redirect @user, :event => :authentication
    else
     session["devise.facebook_data"] = request.env["omniauth.auth"]
     redirect_to new_citizen_registration_url
    end
  end
end