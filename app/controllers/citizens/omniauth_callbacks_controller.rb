class Citizens::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @citizen = Citizen.find_for_facebook_auth(request.env["omniauth.auth"])

    unless @citizen
      @citizen = Citizen.build_from_auth_hash(request.env["omniauth.auth"])
      sign_up = true
    end

    if @citizen.persisted?
      KM.identify(@citizen)
      KM.push("record", "Facebook login")
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Facebook"
      if sign_up
        sign_in @citizen
        redirect_to edit_profile_fi_path
      else
        sign_in_and_redirect @citizen, event: :authentication
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_citizen_registration_url
    end
  end
end