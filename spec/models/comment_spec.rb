require 'spec_helper'

describe Comment do
  it { should belong_to :author }
end
