module Concerns::Indexing
  extend ActiveSupport::Concern
  
  module ClassMethods
    def index_name
      ENV["Index_Name"] || "Development"
    end
  end
end
