module Admin::ChangelogsHelper
  CHARACTERS_AROUND_DIFF = 40

  def changelogged_link_for(changelog)
    link_text = "#{I18n.t('activerecord.models.'+changelog.changelogged_type.downcase)} ##{changelog.changelogged_id}"
    if changelog.changelogged.class == Comment
      comment = changelog.changelogged
      if comment.commentable.class == Idea
        link_to link_text, idea_path(comment.commentable, anchor: "comments")
      elsif comment.commentable.class == Article
        link_to link_text, article_path(comment.commentable, anchor: "comments")
      end
    else
      link_to link_text, changelog.changelogged
    end
  end

  def short_diff(change)
    if change.first.present? && change.last.present?
      diffed = Differ.diff(change.last.to_s, change.first.to_s, '').to_s

      # location of the actual diff
      diff_start = diffed.index("<del class=\"differ\">")
      diff_start ||= diffed.index("<ins class=\"differ\">")
      diff_end = diffed.rindex("</ins>") && (diffed.rindex("</ins>") + "</ins>".length - 1) || nil
      diff_end ||= diffed.rindex("</del>") + "</del>".length - 1

      # take along some extra chars around the diff
      from = [0, diff_start - CHARACTERS_AROUND_DIFF].max
      to = [diffed.to_s.length, diff_end + CHARACTERS_AROUND_DIFF].min
      diff = diffed[from..to]

      # add "&hellip;"s to indicate there is more text out there
      diff.insert(0, '&hellip; ') if from > 0
      diff << ' &hellip;' if to < diffed.length
      diff.html_safe
    else
      Differ.diff(change.last.to_s, change.first.to_s, '').to_s.html_safe
    end
  end
end
