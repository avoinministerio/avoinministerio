class Signature
  # keep in this module all the methods used for parsing params from SignaturesController
  module SignaturesParser

    module InstanceMethods

      def fill_in_acceptances(params={}, session={})
        self.accept_general       = params["accept_general"]  == "1"       || session["authenticated_accept_general"] == "1"
        self.accept_non_eu_server = params["accept_non_eu_server"] == "1"  || session["authenticated_accept_non_eu_server"] == "1"
        self.accept_publicity     = params["publicity"]                    || session["authenticated_accept_publicity"]
        self.accept_science       = params["accept_science"]               || session["authenticated_accept_science"]
        self.accept_science = false if self.accept_science == ''
        self.accept_publicity = params["publicity"]
      end

    end

    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end

  end

end
