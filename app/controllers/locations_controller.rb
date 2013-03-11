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
      location = Geocoder.search("193.208.230.0")
      unless location == []
        @users_lat = location[0].data["latitude"]
        @users_lon = location[0].data["longitude"]
        @users_loc = location[0].data["city"]
      end
    elsif Rails.env == "production"
      location = Geocoder.search(request.ip)
      unless location == []
        @users_lat = location[0].data["latitude"]
        @users_lon = location[0].data["longitude"]
        @users_loc = location[0].data["city"]
      end
    end

     #To prevent bug in development mode
    if Rails.env == "development"
      ip_location_guessing("85.77.239.17")
    elsif Rails.env == "production"
      ip_location_guessing(request.ip)
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

  private
  def ip_location_guessing(ip_address)
    if (cookies[:user_lat] and cookies[:user_lon] and cookies[:user_city]).nil?
      puts "Using API search"
      location = Geocoder.search(ip_address)
      unless location == []
        respond = location[0].data
        @users_lat = respond["latitude"]
        @users_lon = respond["longitude"]
        @users_loc = respond["city"]
        cookies[:user_lat] = { value: respond["latitude"].to_s, expires: 1.week.from_now }
        cookies[:user_lon] = { value: respond["longitude"].to_s, expires: 1.week.from_now }
        cookies[:user_city] = { value: respond["city"].to_s, expires: 1.week.from_now }
      end
    else 
      puts "Using cookies"
      @users_lat = cookies[:user_lat]
      @users_lon = cookies[:user_lon]
      @users_loc = cookies[:user_city]
    end
  end
end
