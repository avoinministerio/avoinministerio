module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    Redcarpet::Markdown.new(renderer, { auto_link: true, tables: true }).render(text).html_safe
  end
  def shorten(text, max_length, cut_characters, ending_sign)
    (text.length < (max_length-cut_characters) ? text : text[0,max_length].gsub(/[\s,.\-!?]+\S+\z/, "")) + " " + ending_sign
<<<<<<< HEAD
  end

  def finnishTime(time)
    sprintf("%d.%d.%d %02d:%02d", time.mday, time.month, time.year, time.hour, time.min)
=======
>>>>>>> front-idea-styling
  end

  def finnishTime(time)
    sprintf("%d.%d.%d %02d:%02d", time.mday, time.month, time.year, time.hour, time.min)
  end

  def finnishDate(time)
    sprintf("%d.%d.%d", time.mday, time.month, time.year)
  end
end

class Numeric
     def format(separator = ',', decimal_point = '.')
         num_parts = self.to_s.split('.')
         x = num_parts[0].reverse.scan(/.{1,3}/).join(separator).reverse
         x << decimal_point + num_parts[1] if num_parts.length == 2
         return x
     end

     def Numeric.format(number, *args)
         number.format(*args)
     end

end
