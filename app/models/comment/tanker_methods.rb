class Comment
  module TankerMethods

    def included(sender)

      sender.class_eval do

        tankit index_name do
          conditions do
            published?
          end
          indexes :body
          indexes :author do
            self.author.first_name + " " + self.author.last_name
          end
          indexes :type do "comment" end

          category :type do
            "comment"
          end
        end
      end

    end
  end
end
