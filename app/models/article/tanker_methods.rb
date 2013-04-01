class Article
  module TankerMethods

    def included(sender)

      sender.class_eval do

        tankit index_name do
          conditions do
            published?
          end
          indexes :title
          indexes :ingress
          indexes :body
          indexes :author do
            self.author.first_name + " " + self.author.last_name
          end
          indexes :type do "article" end

          category :type do
            "article"
          end
        end

      end

    end

  end
end
