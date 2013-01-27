class BootstrapTour < ActiveRecord::Base
  attr_accessible :action, :controller, :is_ended, :step, :user_id
end
