class CitizensController < ApplicationController
  before_filter :authenticate_citizen!, except: :bootstrap_tour_value
  before_filter :fetch_citizen, except: :bootstrap_tour_value
  
  def edit
  end

  def after_sign_up
  end
  
  # based on https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  def update
    if @citizen.update_with_password(params[:citizen])
      flash[:notice] = I18n.t("registrations.edit.password_updated")
      sign_in @citizen, :bypass => true
    end
    render "edit"
  end
  
  def get_bootstrap_tour
    if request.xhr? and request.get? and current_citizen
      begin
        find_params_hash = find_bootstrap_tour_hash()

        bootstrap_tour = BootstrapTour.where(find_params_hash).first
        bootstrap_tour = BootstrapTour.create!(find_params_hash) unless bootstrap_tour
   # binding.pry   # !!!! DEBUG !!!!
        render(json: result_bootstrap_tour_hash(bootstrap_tour))
      rescue 
        render(json: {errors: "an error occurs", status: 500})
      end
    else
      render(json: {errors: "not ajax or not post or not authenticated user", status: 422})
    end
  end

  def update_bootstrap_tour
    if request.xhr? and request.post? and current_citizen
      begin
        find_params_hash = find_bootstrap_tour_hash()
        bootstrap_tour = BootstrapTour.where(find_params_hash).first
        #TODO
        find_params_hash[:is_ended] = params[:key] == "end"           ? (params[:value] == "yes" ? true : false) : false
        find_params_hash[:step]     = params[:key] == "current_step"  ? params[:value] : 0
        unless bootstrap_tour
          bootstrap_tour = BootstrapTour.create!(find_params_hash) 
        else
          bootstrap_tour.update_attributes!(find_params_hash)
        end

        render(json: result_bootstrap_tour_hash(bootstrap_tour).merge({message: "success123", status: 200}))
      rescue 
        render(json: {errors: "an error occurs", status: 500})
      end
    else
      render(json: {errors: "not ajax or not post or not authenticated user", status: 422})
    end

  end

  private

  def find_bootstrap_tour_hash
    {
      action:     params[:source_action], 
      controller: params[:source_controller], 
      user_id:    current_citizen.id
    }
  end

  def result_bootstrap_tour_hash(bootstrap_tour)
    {
      end:          bootstrap_tour.is_ended ? "yes" : "no", 
      current_step: bootstrap_tour.step || "0"
    }
  end
  
  def fetch_citizen
    @citizen = current_citizen
  end
end