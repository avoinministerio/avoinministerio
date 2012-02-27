require 'spec_helper'

describe Citizen do
  it { should have_one :profile }
end
