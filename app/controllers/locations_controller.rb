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
      @users_lat = 60.169845
      @users_lon = 24.9385508
      @users_loc = "Helsinki"
    elsif Rails.env == "production"
      location = GeoLocation.find(request.ip)
      @users_lat = location[:latitude] 
      @users_lon = location[:longitude]
      @users_loc = location[:city]
    end
    
    #31.06 miles ~= 50 km
    @locations_nearby_ip = Location.near([@users_lat, @users_lon], 31.0685596, :order => :distance)

    if params[:address].present?
      @locations_nearby = Location.near([params[:address_latitude], params[:address_longitude]], 31.0685596, :order => :distance)
      #If no results were found within a radius of 50 kms.
      if @locations_nearby.all == []
        #Then increase radius (~1000km) and show 10 sorted by distance
        @locations_nearby = Location.near([params[:address_latitude], params[:address_longitude]], 500, :order => :distance).limit(10)
      end
      @search_location = params[:address]
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
