# encoding: utf-8

module IdeasHelper
  def idea_state_image(idea)
    filename = {
      idea:     "state_1_idea.jpg",
      draft:    "state_2_draft.jpg",
      proposal: "state_3_proposal.jpg"
    }[idea.state]
    
    image_tag(filename, width: 954, height: 62)
  end
  
  def vote_in_words(idea, citizen)
    case idea.votes.by(citizen).first.option
    when 0
      "Ei"
    when 1
      "Kyllä"
    end
  end
end
