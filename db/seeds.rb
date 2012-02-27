#encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Idea.create!([
  { title: "Kansanedustajien palkankorotus pannaan", 
    summary: "Kansanedustajien palkkaa meinataan nostaa miltei 10%. Se on paljon enemmän kuin TUPO. Ei ole soveliaista sietää semmoista.", 
    body: "Ei voida tukea näin suurisuuntaisia ideoita kun ei ole kansalla varaa kuntiinsa!", 
    state: "idea", author_id: 1},
  
  { title: "Poistetaan perintöverotus", 
    summary: "Poistakaa ja ottakaa raha firmoilta ja tasaverolla rikkailta!", 
    body: "Ankarin perintövero korvattakoon tasaverolla!", 
    state: "lakiluonnos", author_id: 2},
  
  { title: "Raiskauksille kunnon tuomiot", 
    summary: "Joku roti!", 
    body: "Suuremmat rangaistukset olisivat linjakkaampia!", 
    state: "lakiesitys", author_id: 3},
  
  { title: "Kaikelle isommat tuomiot", 
    summary: "Joku roti!", 
    body: "Suuremmat rangaistukset olisivat linjakkaampia!", 
    state: "laki", author_id: 4},
  
  { title: "Vielä isommat tuomiot", 
    summary: "Rinta rottingille! Tai rottinkia selkään. Nyt on aika pistää perusrangaistukset kovalle linjalle, ja lopettaa kansan kärsimykset!", 
    body: "Suuremmat rangaistukset olisivat linjakkaampia!", 
    state: "idea", author_id: 5},
])

[
  { email: "joonas@pekkanen.com",
    password: "joonas1", password_confirmation: "joonas1", remember_me: true,
    profile_attributes: {first_name: "Joonas", last_name: "Pekkanen", name: "Joonas Pekkanen"}, },
  
  { email: "arttu.tervo@gmail.com",
    password: "arttu1", password_confirmation: "arttu1", remember_me: true,
    profile_attributes: {first_name: "Arttu", last_name: "Tervo", name: "Arttu Tervo"}, },
  
  { email: "aleksi.rossi@iki.fi",
    password: "aleksi1", password_confirmation: "aleksi1", remember_me: true,
    profile_attributes: {first_name: "Aleksi", last_name: "Rossi", name: "Aleksi Rossi"}, },
  
  { email: "hleinone@gmail.com",
    password: "hannu1", password_confirmation: "hannu1", remember_me: true,
    profile_attributes: {first_name: "Hannu", last_name: "Leinonen", name: "Hannu Leinonen"}, },
  
  { email: "juha.yrjola@iki.fi",
    password: "juhay1", password_confirmation: "juhay1", remember_me: true,
    profile_attributes: {first_name: "Juha", last_name: "Yrjölä", name: "Juha Yrjölä"}, },
  
  { email: "lauri@kiskolabs.com",
    password: "lauri1", password_confirmation: "lauri1", remember_me: true,
    profile_attributes: {first_name: "Lauri", last_name: "Jutila", name: "Lauri Jutila"}, },
  
  { email: "mikael.kopteff@gmail.com",
    password: "mikael1", password_confirmation: "mikael1", remember_me: true,
    profile_attributes: {first_name: "Mikael", last_name: "Kopteff", name: "Mikael Kopteff"}, },
].each { |citizen| Citizen.find_or_create_by_email(citizen) }

def random_citizen_id
  ids = Citizen.all.map(&:id)
  ids[rand(ids.size)]
end

[
  { title: "Kansanedustajien palkankorotus pannaan",
    summary: "Kansanedustajien palkkaa meinataan nostaa miltei 10%. Se on paljon enemmän kuin TUPO. Ei ole soveliaista sietää semmoista.",
    body: "Ei voida tukea näin suurisuuntaisia ideoita kun ei ole kansalla varaa kuntiinsa!",
    state: "idea", author_id: random_citizen_id},
  { title: "Poistetaan perintöverotus",
    summary: "Poistakaa ja ottakaa raha firmoilta ja tasaverolla rikkailta!",
    body: "Ankarin perintövero korvattakoon tasaverolla!",
    state: "lakiluonnos", author_id: random_citizen_id},
  { title: "Raiskauksille kunnon tuomiot",
    summary: "Joku roti!",
    body: "Suuremmat rangaistukset olisivat linjakkaampia!",
    state: "lakiesitys", author_id: random_citizen_id},
  { title: "Kaikelle isommat tuomiot",
    summary: "Joku roti!",
    body: "Suuremmat rangaistukset olisivat linjakkaampia!",
    state: "laki", author_id: random_citizen_id},
  { title: "Vielä isommat tuomiot",
    summary: "Rinta rottingille! Tai rottinkia selkään. Nyt on aika pistää perusrangaistukset kovalle linjalle, ja lopettaa kansan kärsimykset!",
    body: "Suuremmat rangaistukset olisivat linjakkaampia!",
    state: "idea", author_id: random_citizen_id},
].each { |idea| Idea.find_or_create_by_title(idea) }

20.times do |i|
  Idea.create!([
    { title: "Esimerkki-idea #{i}", 
      summary: "Melko tavallisen oloinen esimerkki-idean tiivistelmä, jota ei parane ohittaa olankohautuksella tai saattaa jäädä jotain huomaamatta.", 
      body: "Yleensä esimerkit ovat ytimekkäitä. Joskus ne venyvät syyttä. Tällä kertaa ei käy niin. Oleellista on uniikki sisältö. Tämä idea #{i} on uniikki. Tätä ei ole tässä muodossa missään muualla.", 
      state: "idea", 
      created_at: Time.now - (60*60*24),
      updated_at: Time.now - (60*60*24),
      author_id: random_citizen_id},
  ])
end

voters = (0..100).map do |i|
  Citizen.find_or_create_by_email(
      email: "voter#{i}@voter.com",
      password: "voter#{i}", password_confirmation: "voter#{i}", remember_me: true,
      profile_attributes: {first_name: "Voter", last_name: "#{i}", name: "Voter #{i}"}
    )
end

voter_count = voters.size

ideas = Idea.find(:all).to_a
# first idea has 0 votes
ideas.shift  
# next ideas have only one for and against
Vote.create!({ idea: ideas.shift, citizen: voters[rand(voter_count)], option: 0 })
Vote.create!({ idea: ideas.shift, citizen: voters[rand(voter_count)], option: 1 })

class RandomGaussian
  def initialize(mean = 0.0, sd = 1.0, rng = lambda { Kernel.rand })
    @mean, @sd, @rng = mean, sd, rng
    @compute_next_pair = false
  end

  def rand
    if (@compute_next_pair = !@compute_next_pair)
      # Compute a pair of random values with normal distribution.
      # See http://en.wikipedia.org/wiki/Box-Muller_transform
      theta = 2 * Math::PI * @rng.call
      scale = @sd * Math.sqrt(-2 * Math.log(1 - @rng.call))
      @g1 = @mean + scale * Math.sin(theta)
      @g0 = @mean + scale * Math.cos(theta)
    else
      @g1
    end
  end
end

# the rest should have all kinds of combinations
secs_per_week = 60*60*24*7
ideas.each do |idea|
	rd = RandomGaussian.new(secs_per_week * (rand()*8.0+2.0), secs_per_week * (rand()*4.0+2.0))

	# pick random count of random voters
	vs = []
	(0..rand(voter_count)).each do 
		v = voters[rand(voter_count)]
		while vs.include? v
			v = voters[rand(voter_count)]
		end
		vs.push v
	end
	vs.each do |v|
#		t = Time.now - rand(secs_per_week*10)
		t = Time.now - rd.rand()
		Vote.create!({ idea: idea, citizen: v, option: rand(2), created_at: t, updated_at: t})
	end
end

# let's create some articles

def read_till(f, breaker = /^---+/)
	str = ""
	while((l = f.gets) !~ breaker)
		str.concat l
	end
	str
end

def field(f, name)
	str = f.gets
	if m = str.match(/^#{name}:/)
		return m.post_match
	else
		raise "line #{str} does not match field name #{name}"
	end
end

Dir["articles/*.md"].sort{|a,b| a <=> b}.each do |name|
  next unless File.file?(name)
  File.open(name) do |f|
    article = {
      article_type: field(f, "article_type"),
      created_at:   field(f, "created_at"),
      updated_at:   field(f, "updated_at"),
      citizen:      Citizen.find(field(f, "author")),
      idea:         Idea.find(field(f, "idea")),
      title:        field(f, "title"),
      ingress:      field(f, "ingress") && read_till(f),
      body:         field(f, "body") && read_till(f),
    }
    
    Article.find_or_create_by_created_at(article)
  end
end
