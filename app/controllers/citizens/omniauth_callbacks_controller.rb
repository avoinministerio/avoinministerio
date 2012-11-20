class Citizens::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @citizen = Citizen.find_for_facebook_auth(request.env["omniauth.auth"])

    unless @citizen
      @citizen = Citizen.build_from_auth_hash(request.env["omniauth.auth"])
    end

    if @citizen.persisted?
      KM.identify(@citizen)
      KM.push("record", "Facebook login")
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Facebook"
      sign_in_and_redirect @citizen, event: :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_citizen_registration_url
    end
  end
end
