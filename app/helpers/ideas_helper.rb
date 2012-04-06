# encoding: utf-8

module IdeasHelper
  def idea_state_image(idea)
    filename = {
      idea:     "state_1_idea.png",
      draft:    "state_2_draft.png",
      proposal: "state_3_proposal.png",
      law:      "state_4_law.png",
    }[idea.state.to_sym]
    
    image_tag(filename, width: 954, height: 62)
  end

  def state_localised(state)
    states = { 
      "idea" => "idea", 
      "draft" => "luonnos", 
      "proposal" => "aloite", # TODO needs to be cleaned up after migrated to two types of proposals
      "law proposal" => "lakialoite", 
      "action proposal" => "toimenpidealoite", 
      "law" => "laki"}
    raise "invalid state '#{state.inspect}'" unless states.keys.include? state
    states[state]
  end
  
  def vote_in_words(idea, citizen)
    case idea.votes.by(citizen).first.option
    when 0
      "Ei"
    when 1
      "Kyllä"
    end
  end
  
  def shortened_summary(summary, max_length, cut_characters, ending_sign)
    shorten(Nokogiri::HTML(markdown(summary)).text, max_length, cut_characters, ending_sign)
  end
end
