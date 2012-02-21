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

Citizen.create!([
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

])

voters = (0..100).map do |i|
	Citizen.create!({
		email: "voter#{i}@voter.com", 
	  	password: "voter#{i}", password_confirmation: "voter#{i}", remember_me: true, 
	  	profile_attributes: {first_name: "Voter", last_name: "#{i}", name: "Voter #{i}"}, },		
	)
end

#citizens = Citizen.find(:all).to_a
#citizen_count = citizens.size

voter_count = voters.size

ideas = Idea.find(:all).to_a
# first idea has 0 votes
ideas.shift  
# next ideas have only one for and against
Vote.create!({ idea: ideas.shift, citizen: voters[rand(voter_count)], option: 0 })
Vote.create!({ idea: ideas.shift, citizen: voters[rand(voter_count)], option: 1 })

# the rest should have all kinds of combinations
ideas.each do |idea|
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
		Vote.create!({ idea: idea, citizen: v, option: rand(2) })
	end
end
