class Citizens::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    omniauth = request.env["omniauth.auth"]
    
    #TODO Handle current_user situation
    @citizen = Citizen.find_for_facebook_oauth(omniauth)

    if @citizen.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Facebook"
      sign_in_and_redirect @citizen, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_citizen_registration_url
    end
  end
end