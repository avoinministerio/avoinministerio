require 'test_helper'
require 'rails/performance_test_help'
require 'ruby-prof'

class LocationsPageTest < ActionDispatch::PerformanceTest
  self.profile_options = { :runs => 5, :metrics => [:wall_time, :memory, :objects, :gc_runs, :gc_time],
  	                       :output => 'tmp/performance', :formats => [:flat] }

  def test_kartta
    get '/kartta'
  end
end
