class Admin::AdminController < ApplicationController
  include Admin::AdminHelper
  
  layout "admin"
  
  before_filter :authenticate_administrator!
end