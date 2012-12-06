class Idea
  module  FormattingMethods
    extend ActiveSupport::Concern

    module ClassMethods

      def load_row_with_counts(state, count)
        if state == "proposal"
          items = Idea.published.ongoing.where(state: state).order("updated_at DESC").limit(300).includes(:votes).all.shuffle![0..count-1]
        else
          items = Idea.published.where(state: state).order("updated_at DESC").limit(count).includes(:votes).all
        end
        item_counts = {}

        items.each do |idea|
          for_count       = idea.vote_counts[1] || 0
          against_count   = idea.vote_counts[0] || 0
          comment_count   = idea.comments.count()
          total           = for_count + against_count
          for_portion     = (    for_count > 0 ?     for_count / total.to_f  : 0.0)
          against_portion = (against_count > 0 ? against_count / total.to_f  : 0.0)
          for_            = sprintf("%2.0f%%", for_portion * 100.0)
          against_        = sprintf("%2.0f%%", against_portion * 100.0)
          item_counts[idea.id] = [for_portion, for_, against_portion, against_]
        end

        return items, item_counts
      end

      private :load_row_with_counts

      def proposals_row(number_of_rows=1)
        load_row_with_counts "proposal", 9*number_of_rows
      end

      def drafts_row(number_of_rows=1)
        load_row_with_counts "draft", 9*number_of_rows
      end

    end

    module InstanceMethods

      def formatted_idea_counts
        for_count      = vote_counts[1] || 0
        against_count  = vote_counts[0] || 0
        comment_count  = comments.count()
        total = for_count + against_count
        if total == 0
          ["0%", "0%", comment_count, total]
        else
          total = for_count + against_count
          [
            sprintf("%2.0f%%", (    for_count > 0 ?     for_count / total.to_f * 100.0  : 0.0)), 
            sprintf("%2.0f%%", (against_count > 0 ? against_count / total.to_f * 100.0  : 0.0)),
            comment_count, 
            total.format(" ")
          ]
        end
      end

    end

  end
end
