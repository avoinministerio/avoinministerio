# encoding: UTF-8
module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    base.send :layout, 'application'
  end

  # Actions
  def new
    super
    # @title = "You can take these surveys"
  end
  def create
    super
  end
  def show
    super
  end
  def edit
    super
  end
  def update
    super
  end

  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    #super # available_surveys_path
    root_url
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    #super # available_surveys_path
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end
end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
