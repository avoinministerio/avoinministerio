module RedcarpetVideo

  class HtmlWithVideo < Redcarpet::Render::HTML
    def block_html(raw_html)
      if raw_html =~ /^<iframe.*>$/ 
         raw_html.html_safe
      end
    end
  end

end
