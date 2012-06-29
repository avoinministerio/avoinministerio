# encoding: utf-8

require "cgi"

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
  
  def shorten_and_highlight(text, pattern, max_length, starting_sign, ending_sign)
    # highlighting is case insensitive, which requires a regular expression
    regex = build_regex(pattern)
    escaped_text = CGI.escapeHTML(text)
    first_match_index = escaped_text.index(regex)
    if first_match_index.nil?
      # the pattern doesn't match the text
      return shorten(escaped_text, max_length, max_length/10, ending_sign)
    end
    highlighted_part_length = ('<span class="match">' + pattern + '</span>').length
    if first_match_index + highlighted_part_length > max_length
      # we need to truncate the string at the beginning
      if highlighted_part_length < max_length
        space_left = max_length - highlighted_part_length
        start_index = first_match_index - space_left/2
      else
        # highlighted result won't fit in the truncated string,
        # so let's not highlight
        return shorten(escaped_text, max_length, max_length/10, ending_sign)
      end
    else
      start_index = 0
    end
    highlighted_text = escaped_text.gsub(regex,
      '<span class="match">\k<match></span>')
    shortened_text = highlighted_text[start_index, max_length] + " " + ending_sign
    if start_index > 0
      shortened_text.insert(0, starting_sign + " ")
    end
    return shortened_text
  end
  
  def build_regex(pattern)
    local_pattern = String.new(pattern)
    # remove quotes
    local_pattern.gsub!('"','')
    # a term can be prefixed with a field name: remove such prefixes
    local_pattern.gsub!(/^.+?:/,"")
    # a term can be suffixed with desired priority: remove such suffixes
    local_pattern.gsub!(/\^.+$/,"")
    # remove asterisks
    local_pattern.gsub!("*","")
    Regexp.new('(?<match>' + Regexp.escape(local_pattern) + ')',
      Regexp::IGNORECASE)
  end
end
