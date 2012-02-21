module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    Redcarpet::Markdown.new(renderer, { auto_link: true, tables: true }).render(text).html_safe
  end
  def shorten(text, max_length, cut_characters, ending_sign)
  	(text.length < (max_length-cut_characters) ? text : text[0,max_length].gsub(/[\s,.\-!?]+\S+$/, "")) + " " + ending_sign
  end
end
