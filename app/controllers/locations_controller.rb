require 'will_paginate/array'
class LocationsController < ApplicationController

  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end
  
  def map
    @cloudmade_api_key = ENV['CLOUDMADE_API_KEY']
    #To prevent bug in development mode
    if Rails.env == "development"
      @users_lat = Geocoder.coordinates("Helsinki")[0]
      @users_lon = Geocoder.coordinates("Helsinki")[1]
      @users_loc = "Helsinki"
    elsif Rails.env == "production"
      Geocoder.configure(:timeout => 500)
      @users_city = request.location.city
      @users_lat = Geocoder.coordinates(@users_city)[0]
      @users_lon = Geocoder.coordinates(@users_city)[1]
      @users_loc = request.location.city
    end
    
    #31.06 miles ~= 50 km
    @locations_nearby_ip = Location.near(@users_loc, 31.0685596, :order => :distance)

    if params[:search].present?
      @locations_nearby = Location.near(params[:search], 31.0685596, :order => :distance)
      #If no results were found within a radius of 50 kms.
      if @locations_nearby.all == []
        #Then increase radius (~1000km) and show 10 sorted by distance
        @locations_nearby = Location.near(params[:search], 500, :order => :distance).limit(10)
      end
      @search_location = Geocoder.coordinates(params[:search])
    end

    @locations = Location.find(:all, :order => 'name')
  end

  def addresses
    @locations = Location.find(:all, :order => 'name').paginate(:page => params[:page], :per_page => 30)
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    @location.save
    redirect_to :back
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    redirect_to :back
  end
end
