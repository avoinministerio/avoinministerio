# encoding: UTF-8
class Idea
  module KissMetricsMethods
    extend ActiveSupport::Concern

    module ClassMethods

      def prepare_kiss_metrics
        KM.set({"section_count" => "2"})
        ["proposal_and_draft", "draft", "proposal"].each do |section|
          3.times do |i|
            section_index_link = "ab_section_#{section}_#{i}_link"
            KM.track(section_index_link, section_index_link)            # track both, which section and which item
            KM.track(section_index_link, "ab_section_#{section}_link")  # track only which section got the click
          end
        end
      end

      def ideas_tracking(number_of_ideas)
        number_of_ideas.times do |i|
          KM.track("ab_ideas_#{i}", "ab_ideas_#{i}")    # track both, which section and which item
          KM.track("ab_ideas_#{i}", "ab_ideas")         # track just idea section got the click
        end
      end

    end

  end
end
