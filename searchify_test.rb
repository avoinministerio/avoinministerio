require 'rubygems'
require 'indextank'

# private: http://:47fXqhMIQQuoLU@4na.api.searchify.com
# public: http://4na.api.searchify.com

api_url = "http://:47fXqhMIQQuoLU@4na.api.searchify.com"
api = IndexTank::Client.new api_url

index = api.indexes "MyFirstIndex"
index.add

while not index.running?
    sleep 0.5
end


docid = "MyDoc"
text = "some sample text"
index.document(docid).add({ :text => text })

results = index.search "some text"

print results['matches'], " results\n"
results['results'].each {|doc|
    docid = doc['docid']
    print "docid: #{docid}" 
}
