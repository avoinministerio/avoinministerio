unless GeoLocation == nil
# Use Hostip (free) GeoLocation::use = :hostip
  GeoLocation::use = :hostip
# Use Max Mind (paid) 
# For more information visit: www.maxmind.com/app/city 
# GeoLocation::use = :maxmind GeoLocation::key = ‘YOUR MaxMind.COM LICENSE KEY’ 
# This location will be used while you develop rather than hitting the maxmind.com api 
# GeoLocation::dev = ‘US,NY,Jamaica,40.676300,-73.775200’ 
# IP: 24.24.24.24 # Use this IP in development mode (development and testing will give you 127.0.0.1) 
# GeoLocation::dev_ip = ‘24.24.24.24’
end