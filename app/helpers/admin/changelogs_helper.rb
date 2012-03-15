module Admin::ChangelogsHelper
  CHARACTERS_AROUND_DIFF = 40

  def short_diff(change)
    if change.first.present? && change.last.present?
      diffed = Differ.diff(change.last.to_s, change.first.to_s, 'i').to_s

      # location of the actual diff
      diff_start = diffed.index("<del class=\"differ\">")
      diff_end = diffed.rindex("</ins>") + "</ins>".length - 1

      # take along some extra chars around the diff
      from = [0, diff_start - CHARACTERS_AROUND_DIFF].max
      to = [diffed.to_s.length, diff_end + CHARACTERS_AROUND_DIFF].min
      diff = diffed[from..to]

      # add "&hellip;"s to indicate there is more text out there
      diff.insert(0, '&hellip; ') if from > 0
      diff << ' &hellip;' if to < diffed.length
      diff.html_safe
    else
      Differ.diff(change.last.to_s, change.first.to_s, 'i').to_s.html_safe
    end
  end
end
