class Citizen
  module TankerMethods

    def included(sender)

      sender.class_eval do

        tankit index_name do
          conditions do
            published_something?
          end
          indexes :first_name
          indexes :last_name
          indexes :name
          indexes :type do
            "citizen"
          end

            category :type do
              "citizen"
            end
          end

        end
    end

  end
end
