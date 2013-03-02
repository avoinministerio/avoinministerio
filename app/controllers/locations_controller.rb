class LocationsController < ApplicationController
  
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end
  
  def map
    if Rails.env == "development"
      @users_lat = Geocoder.coordinates("Helsinki")[0]
      @users_lon = Geocoder.coordinates("Helsinki")[1]
    elsif Rails.env == "production"
      @users_lat = Geocoder.coordinates(request.location.city)[0]
      @users_lon = Geocoder.coordinates(request.location.city)[1]
    end
    @locations = Location.all
  end

  def create
    @location = Location.new(params[:location])
    @location.save
    redirect_to :back
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end
end
