class LocationsController < ApplicationController
  layout false

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
      @users_loc = "Helsinki"
    elsif Rails.env == "production"
      @users_lat = Geocoder.coordinates(request.location.city)[0]
      @users_lon = Geocoder.coordinates(request.location.city)[1]
      @users_loc = request.location.city
    end

    @locations_nearby_ip = Location.near(@users_loc, 50, :order => :distance)

    if params[:search].present?
      @locations_nearby = Location.near(params[:search], 50, :order => :distance)
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
