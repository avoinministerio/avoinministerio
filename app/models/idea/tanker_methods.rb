class Idea
  module TankerMethods

    def included(sender)

      sender.class_eval do

        tankit index_name do
          conditions do
            published?
          end
          indexes :title
          indexes :summary
          indexes :body
          indexes :state
          indexes :author do
            self.author.first_name + " " + self.author.last_name
          end
          indexes :type do
            "idea"
          end

          category :type do
            "idea"
          end

          category :state do
            state
          end
        end
      end

    end
  end
end
