module PagesHelper

  def new_proposals_column?(proposal_index)
    (proposal_index % 2) == 0
  end

  def end_of_proposals_column?(proposal_index)
    (proposal_index %2) == 1
  end

  def proposal_column_class(proposal_index)
    case ((proposal_index / 2) % 3)
      when 0 then ""
      when 1 then "class='middle'"
      when 2 then ""
    end
  end

  def idea_popularity_colors(idea)
    # returns array of pairs [green, red]. Shade depends on total count of votes
    case idea.vote_count
      when 0..100 then ["#5cd65c", "#ff5c33"]
      when 101..1000 then ["#85c27a", "#e06666"]
      when 1001..5000 then ["#5cad4e", "#d63333"]
      else ["#339922", "#cc0000"]
    end
  end

end
