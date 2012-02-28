# encoding: utf-8

module IdeasHelper
  def idea_state_image(idea)
    filename = {
      idea:     "state_1_idea.png",
      draft:    "state_2_draft.png",
      proposal: "state_3_proposal.png",
      law:      "state_4_law.png",
    }[idea.state.to_sym]

    unless filename
      logger.error("We cannot convert #{idea.state} to symbol that matches some state")
      logger.info(idea.inspect)
      logger.info(idea.state.inspect)
      logger.info(idea.state.to_sym.inspect)
      logger.info(filename.inspect)
      logger.info(image_tag(filename, width: 954, height: 62).inspect)
    end
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
