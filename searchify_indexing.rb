require 'rubygems'
require 'indextank'


api_url = "http://:47fXqhMIQQuoLU@4na.api.searchify.com"
api = IndexTank::Client.new api_url

def add_indexes(*names)
  indexes = names.map do |name|
    index = api.indexes name
    index.add
  end

  until indexes.all? {|i| i.running? } 
    puts "Waiting index #{name} running..."
      sleep 0.3
  end
  indexes
end

ideas, comments, articles = add_index("Ideas", "Comments", "Articles")


# ideat
  # title, summary, body, author name, updated timestamp
# kommentit
  # comment, author name, updated timestamp
# artikkelit
  # title, summary, body, author name, updated timestamp

Idea.all.each do |idea|
  ideas.document(idea.id).add({ :title => idea.title, :summary => idea.summary, :body => idea.body, 
    :author => idea.author.first_name + " " + idea.author.last_name })
end

res = ideas.search "aloite"
puts res['matches']
res['matches'].each do |doc|
  puts doc['docid']
end
