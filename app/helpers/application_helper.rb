# TUPAS requests require SHA256 MAC calculations
require 'digest/sha2'

module ApplicationHelper
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    Redcarpet::Markdown.new(renderer, { autolink: true, tables: true }).render(text).html_safe
  end
  def shorten(text, max_length, cut_characters, ending_sign)
    (text.length < (max_length-cut_characters) ? text : text[0,max_length].gsub(/[\s,.\-!?]+\S+\z/, "")) + " " + ending_sign
  end

  def finnishTime(time)
    sprintf("%d.%d.%d %02d:%02d", time.mday, time.month, time.year, time.hour, time.min)
  end

  def finnishDate(time)
    if time.is_a? String
      time = DateTime.parse(time)
    end
    sprintf("%d.%d.%d", time.mday, time.month, time.year)
  end

end

def current_timezone
  timezone = ENV['FinnishTimezone'] || 3.0/24   # TODO: needs to be changed into GMT+2 for winter time
end

def today_date(timezone = current_timezone)
  # changes UTC time into Finnish timezone and then converts it to date, yielding correct date around midnight
  DateTime.now.new_offset(timezone).to_date   
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


# KissMetrics helper, that generates KM javascript
require 'digest/sha1'

class KM
  $pushes ||= []
  $sets ||= []
  $tracks ||= []

  def KM.track(element_id, event_name)
    $tracks.push [element_id, event_name]
  end

  def KM.set(params)
    $sets.push [params.to_json]
  end

  def KM.push(command, event_name, params=nil)
    if params
      $pushes.push [command, event_name, params.to_json]
    else
      $pushes.push [command, event_name]
    end
  end

  # if no user id given, create default by logged in user email hash, or "null" if not logged in
  def KM.identify(current_citizen)
    if current_citizen
      identify = Digest::SHA1.new.update(current_citizen.email + api_key).hexdigest
    else 
      identify = "null"
    end
    KM.push("identify", identify)
  end

  def KM.api_key
    ENV['KISSMETRICS_API_KEY'] || ""
  end

  def KM.js
    if $pushes
      recs = $pushes.map do |pu| 
        if pu[2]
          "_kmq.push(['#{pu[0]}', '#{pu[1]}', #{pu[2]}]);"
        else
          "_kmq.push(['#{pu[0]}', '#{pu[1]}']);"
        end
      end.join("\n")
      $pushes = []

      sets = $sets.map do |se|
        "_kmq.push(['set', #{se[0]}]);"
      end.join("\n")
      $sets = []

      tracks = $tracks.map do |tr|
        "_kmq.push(['trackClick', '#{tr[0]}', '#{tr[1]}' ]);"
      end.join("\n")
      $tracks = []

      "var _kmq = _kmq || [];
      function _kms(u){
        setTimeout(function(){
          var s = document.createElement('script'); 
          var f = document.getElementsByTagName('script')[0]; 
          s.type = 'text/javascript'; 
          s.async = true;
          s.src = u; 
          f.parentNode.insertBefore(s, f);
        }, 1);
      }
      _kms('//i.kissmetrics.com/i.js');_kms('//doug1izaerwt3.cloudfront.net/#{KM.api_key}.1.js');
      #{recs}
      #{sets}
      #{tracks}
      "
    else
      ""
    end
  end
end

