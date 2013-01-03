module PagesHelper
  def idea_reason(idea)
    case idea.version_reference[0]
    when 0
      "Got 100 votes more in favor. Total votes: #{idea.vote_count}"
    when 1
      "Idea state changed from '#{idea.version_reference[1]}' to '#{idea.version_reference[2]}'"
    when 2
      "New Idea created"
    when 3
      "Idea got a comment recently. Total comments: #{idea.comment_count}"
    else
      "Idea was recently in news"
    end
  end
end
