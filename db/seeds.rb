#encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'factory_girl_rails'

Administrator.find_or_create_by_email({
  email: "admin@avoinministerio.fi",
  password: "hallinta"
})

[
  { email: "joonas@pekkanen.com",
    password: "joonas1", password_confirmation: "joonas1", remember_me: true,
    profile_attributes: {first_names: "Joonas", first_name: "Joonas", last_name: "Pekkanen", name: "Joonas Pekkanen"}, },
  
  { email: "arttu.tervo@gmail.com",
    password: "arttu1", password_confirmation: "arttu1", remember_me: true,
    profile_attributes: {first_names: "Arttu", first_name: "Arttu", last_name: "Tervo", name: "Arttu Tervo"}, },
  
  { email: "aleksi.rossi@iki.fi",
    password: "aleksi1", password_confirmation: "aleksi1", remember_me: true,
    profile_attributes: {first_names: "Aleksi", first_name: "Aleksi", last_name: "Rossi", name: "Aleksi Rossi"}, },
  
  { email: "hleinone@gmail.com",
    password: "hannu1", password_confirmation: "hannu1", remember_me: true,
    profile_attributes: {first_names: "Hannu", first_name: "Hannu", last_name: "Leinonen", name: "Hannu Leinonen"}, },
  
  { email: "juha.yrjola@iki.fi",
    password: "juhay1", password_confirmation: "juhay1", remember_me: true,
    profile_attributes: {first_names: "Juha", first_name: "Juha", last_name: "Yrjölä", name: "Juha Yrjölä"}, },
  
  { email: "lauri@kiskolabs.com",
    password: "lauri1", password_confirmation: "lauri1", remember_me: true,
    profile_attributes: {first_names: "Lauri", first_name: "Lauri", last_name: "Jutila", name: "Lauri Jutila"}, },
  
  { email: "mikael.kopteff@gmail.com",
    password: "mikael1", password_confirmation: "mikael1", remember_me: true,
    profile_attributes: {first_names: "Mikael", first_name: "Mikael", last_name: "Kopteff", name: "Mikael Kopteff"}, },
].each { |citizen| Citizen.find_or_create_by_email(citizen) }

@citizens = Citizen.all

def random_citizen
  @citizens[rand(@citizens.size)]
end

joonas = Citizen.where(email: "joonas@pekkanen.com").first
koiravero_body = <<EOS

Yleisperustelut
=========

### Nykytilan arviointi

1. Koiraveron historiallinen tausta
    - 1800-luvun tausta (vesikauhu yms)
2. Perustelut koiraveron kumoamiselle
    - ks aikaisemmat eduskuntakeskustelut
    - valvonnan puute
    - oikeudenmukaisuus
    - koiraveroa ei korvamerkitty mitenkään esim. koirapuistojen ylläpitoon
    - muistakaan lemmikeistä ei peritä erillisveroa
    - muutkin harrastukset (esim liikuntahallit) ilman erillisveroja
    - eri kunnissa asuvat erilaisessa asemassa

### Esityksen vaikutukset

1. Taloudelliset vaikutukset
    - Veron menetykset Hgille ja Treelle
2. Vaikutukset koiranomistajille
    - vähentää turhaa työtä
    - asettaa tasavertaiseen asemaan
3. Vaikutukset viranomaisten toimintaan
    - säästyy työtä kaupungilta

### Asian valmistelu

1. Valmisteluvaiheet
    - Esitys valmistellaan Avoimessa ministeriössä yhteistyössä avoimesti ja osallistavasti kansalaisaloitteena. Luonnos julkaistaan avointa kommentointia varten 1.3.2011 Avoimen ministeriön nettisivuilla, jossa sen puolesta ja vastaan voivat kansalaiset jättää tuenilmaisunsa. Kansalaispalautteen ja lausuntojen perusteella tästä luonnoksesta muokataan lopullinen lakiehdotuksen muodossa oleva kansalaisaloite, jolle pyritään keräämään 50,000 virallista tuenilmaisua vuoden 2012 aikana.
2. Lausunnot ja niiden huomioon ottaminen
    - Koiraveron kumoamisesta pyydetään lausunnot Kennelliitolta ja Kuntaliitolta sekä toivotetaan lausunnot muilta tahoilta tervetulleiksi. (tähän yhteenvedot eri lausunnoista) 

Lakiehdotus
========

__Laki__
__koiraverolain kumoamisesta__

1 §
_Koiraverolain kumoaminen_

Tällä lailla kumotaan koiraverosta 2.9 päivänä kesäkuuta 1979 annettu laki (590/1979) siihen myöhemmin tehtyine muutoksineen.

2 §
_Voimaantulo_

Tämä laki tulee voimaan 1. päivänä tammikuuta 2013.
EOS

opintotuki_body = <<EOS

Yleisperustelut
===============

### Nykytila ja ehdotetut muutokset

#### Tukikuukauden menettäminen takaisinperinnän yhteydessä

Opintotukikuukauden menettämisestä takaisinperinnän yhteydessä säädetään opintotukilain (65/1994) 7 b §:ssä (1099/2000). Lain 7 b §:n 3 momentin mukaan takaisinperintä ei palauta tukikuukautta uudelleen käytettäväksi, ellei takaisinperintä aiheudu virheellisestä maksatuksesta tai 6 §:ssä tarkoitetun etuuden takautuvasta maksatuksesta.

Lukuvuonna 2010/2011 opintorahaa maksettiin 295 tuhannelle ja asumislisää 194 tuhannelle opiskelijalle yhteensä 772 miljoonaa euroa.  Vuoden 2011 keväällä tukia perittiin takaisin 29 294 opiskelijalta vuoden 2010 tulovalvontaan perustuen. Yhteensä tukia perittiin takaisin 36,1 miljoonan euron edestä, josta 31,4 miljoonaa oli tukia ja 15 prosenttia eli 4,7 miljoonaa euroa opiskelijoilta perittäviä rangaistusluonteisia korotusmaksuja. Keskimääräinen takaisinperintä vuonna 2012 on 1232 euroa eli 1071 euroa lisättynä 15 prosentin korotuksella. Keskimäärin takaisinperintä koskee siis kolmea tukikuukautta, kun opintotuki ja asumislisä lukuvuonna 2010/2011 olivat keskimäärin 360 euroa. 

Valmistuvilla opiskeilijoilla jää keskimäärin kaksi opintotukikuukautta käyttämättä heidän valmistuessaan. Onkin oletettavaa, että takaisinperinnän yhteydessä palauttamatta jäävät tukikuukaudet haittaavat ennen kaikkea heikoimmassa asemassa olevia opiskelijoita, joilla ei opiskelujen loppuvaiheessa jää tukikuukausia käyttämättä. Tukikuukausien palauttamatta jättäminen rankaisee kohtuuttomasti myös niitä, jotka ovat huolimattomuudessaan laskeneet tulonsa väärin, ja menettävät pysyvästi tukikuukautensa ilman tarkoitusta väärinkäyttää järjestelmää.

#### Opintotuen takaisinperinnän korotus

Opintotuen takaisinperinnästä säädetään opintotukilain (65/1994) 27 §:ssä. Lain 27 §:n 5 momentin mukaan opiskelijan omien tulojen perusteella takaisinperittäväksi määrätyn opintorahan ja asumislisän määrää korotetaan 15 prosentilla, jollei valtioneuvoston asetuksella säädetä alemmasta korotuksesta.

Nykytilaa on perusteltu 15 prosentin korotuksen ohjaavalla vaikutuksella. Tuen vapaaehtoista palauttamista on pidetty opiskelijalle edullisempana vaihtoehtona kuin tuen takaisinperintä, sillä takaisinperintä ei palauta tukikuukautta uudelleen käytettäväksi ja takaisinperittävään määrään lisätään 15 prosentin korotus. Korotuksen tarkoituksena on ollut osaltaan ohjata opiskelijaa palauttamaan liikaa saatu tuki vapaaehtoisesti määräaikaan mennessä. Korotus on ollut kertaluonteinen eikä takaisinperittävälle määrälle ole kertynyt muuta korkoa. Korotuksen kertaluonteisuuden on perusteltu myös joissain tilanteissa olevan opiskelijan eduksi, kun mahdollisen muutoksenhakuprosessin aikana ei kerry muita maksuja tai korkoja.

Opintotuen takaisinperinnän korotusmaksua ehdotetaan muutettavaksi kiinteästä 15 prosentista normaaliksi viivästyskoroksi. Korkolain (340/2002) mukainen vuosittainen viivästyskorko on ehdotuksen laatimishetkellä 8 prosenttia. 

Valtio kerää rangaistusluonteisina korotusmaksuina 4,7 miljoonaa vuodessa takaisinperinnän yhteydessä. Korotusmaksun ohjaavuudesta verratuna normaalin viivästyskoron perimiseen ei ole erityistä näyttöä. Oletus on ollut, että rangaistusluonteisella 15 prosentin korotusmaksulla olisi ennaltaehkäisevä vaikutus opintotukea tahallaan liikaa nostavien opiskelijoiden epätoivottavaan käytökseen. On kuitenin mahdollista, että iso osa liikaa nostetuista tukikuukausista ei johdu tahallisista väärinkäytöksistä, jolloin korotuksen ennaltaehkäisevä rangaistusvaikutus on kyseenalainen tai jopa vahingollinen. Vuonna 2012 yli 5000 opiskelijalle takaisinperintää haetaan ulosoton kautta.

Muista oikeustoimista johtuvista velvoitteista aihetuville koroille on korkolaissa annettu yläraja, eikä ole perusteltua syytä poiketa siitä opintotukilain kohdalla. Lisäksi kiinteä 15 prosentin korko ei ota huomioon käyvän korkotason muutoksia. Ehdotuksen laatimishetkellä Euroopan keskuspankin määrittämä ohjauskorko on vain 1,0 prosenttia, kun kyseisen momentin hyväksymishetkellä (joulukuussa 2000) ohjauskorko oli 4,75%.

Tavoitteena on saattaa opiskelijat ja heidän opintotuen ja asumislisän takaisinperintä tasavertaiseksi ja yhteensopivaksi muiden kansalaisten ja heidän oikeustoimiensa kanssa maksun viivästymisen tai huolimattomuuden osalta.

### Esityksen vaikutukset
#### Taloudelliset vaikutukset

Ehdotetulla muutoksella takaisinperintää koskevien tukikuukausien palauttamisesta opiskelijan käyttöön on kohtalaiset valtiotaloudelliset vaikutukset. Takaisinperintää koskevien opintotukikuukausien lukumäärä vuonna 2009 oli 69 000. Kaikkia näitä ehdotetussa mallissa palautettavia opintotukikuukausia ei ikinä käytettäisi, sillä 24%:lla valmistuvista opiskelijoista jää tukikuukausia käyttämättä (keskimäärin valmistuvilla jää kaksi tukikuukautta käyttämättä).  Mikäli 76% palautetuista tukikuukausista käytetään, siitä aiheutuisi valtiolle vuositasolla noin 21 miljoonan euron lisäkustannus.

Ehdotetuilla muutoksella takaisinperinnän korotukseen ei ole merkittäviä valtiontaloudellisia vaikutuksia. Tukivuoden 2010 tulovalvonnan perusteella takaisinperintäpäätöksiä tehtiin 29 294 kappaletta yhteensä noin 36,1 miljoonaa euroa, josta 15% korotuksen osuus on noin 4,7 miljoonaa euroa. Tällä hetkellä takaisinmaksu tapahtuu keskimäärin kahden vuoden kuluttua tuen liikamaksusta. Ehdotuksen mukainen koron sitominen kulloinkin voimassaolevaan viivästyskorkoon kannustaisi takaisinperinnän kohteena olevia maksamaan takaisinperittävän summan aiemmin takaisin, sillä nykyisessä mallissa ei takaisinmaksun venyttämisestä aiheudu kertaluonteisen 15 prosentin korotuksen lisäksi mitään kustannuksia opiskelijalle. Oletuksella, että ehdotetulla mallilla takaisinmaksu tapahtuisi keskimäärin 1,5 vuotta tulovalvonta vuoden päättymisen jälkeen, olisi vastaava korkojen osuus 2,6 miljoonaa euroa ehdotuksen laatimishetken 8 prosentin viivästyskorolla laskettuna. Opiskelijoilta perittäisiin ehdotetussa mallissa korkoina tai korotuksina siis arviolta 2 miljoonaa euroa vähemmän kuin nykymallissa.

Yhteensä ehdotettujen muutosten  arvioidaan kasvattavan valtion menoja enintään 24 miljoonalla eurolla vuositasolla, mikä vastaa 0,9 prosenttia 772 miljoonasta eurosta, joka vuosittain maksetaan opintotukina ja asumislisänä.

#### Vaikutukset opiskeluun ja opiskelijan asemaan

Ehdotetut muutokset parantaisivat opiskelijoiden tilannetta. Ne opiskelijat, joiden tukikuukaudet ovat loppumassa, ovat haavoittuvimmassa asemassa. Ennen kaikkea näiden heikoimmassa tilanteessa olevien opiskelijoiden olevien asema paranisi, kun tukikuukaudet saisi takaisin käyttöön. Tukikuukausien palauttaminen voi osaltaan lyhentää valmistusmisaikoja, kun taloudellisiin vaikeuksiin joutuneita opiskelijoita ei rangaista lisää vaan he voivat suorittaa opintonsa loppuun opintotuen avulla. Takaisinperintään liittyvän kiinteän 15 prosentin koron muuttaminen normaaliksi viivästyskoroksi kohtelisi opiskelijoita tasavertaisesti muiden kansalaisten kanssa ja kannustaisi maksamaan takaisinperittävät tuet takaisin kohtuullisessa ajassa. 

#### Vaikutukset viranomaisten toimintaan

Muutokset edellyttäisivät pienimuotoisia muutoksia Kansaneläkelaitoksen tietojärjestelmiin, ohjeisiin, lomakkeisiin, asiakastiedotukseen ja verkkopalveluihin.

### Asian valmistelu
#### Valmisteluvaiheet

Esitys valmistellaan Avoimessa ministeriössä yhteistyössä avoimesti ja osallistavasti kansalaisaloitteena. Luonnos julkaistaan avointa kommentointia varten 1.3.2011 Avoimen ministeriön nettisivuilla, jossa sen puolesta ja vastaan voivat kansalaiset jättää tuenilmaisunsa. Kansalaispalautteen ja lausuntojen perusteella tästä luonnoksesta muokataan lopullinen lakiehdotuksen muodossa oleva kansalaisaloite, jolle pyritään keräämään 50,000 virallista tuenilmaisua vuoden 2012 aikana.

#### Lausunnot ja niiden huomioon ottaminen

Opintotuen takaisinperinnän koron muuttamisesta ja tukikuukausien palauttamisesta opiskelijan käyttöön tullaan pyytämään lausunnot Kansaneläkelaitokselta ja Verohallinnolta, kun kansalaisten näkemykset on ensin tuotu esiin tässä luonnoksessa. Lausuntojen sisältö tuodaan esiin tässä osiossa.

Avoimen ministeriön esityksen luonnoksesta on pyydetään ennen lopullista lakiehdotusta lausunnot valtiovarainministeriöltä ja opiskelijajärjestöiltä, mukkan lukien Suomen ylioppilaskuntien liitto (SYL), Suomen ammattikorkeakouluopiskelijakuntien liitto - SAMOK sekä Suomen Lukiolaisten Liitto. (tähän yhteenvedot eri lausunnoista)

Yksityiskohtaiset perustelut
============================

__1. Laki opintotukilain muuttamisesta__


7 b §. _Tukikuukauden käyttäminen_. Pykälän 3 momenttia ehdotetaan muutettavaksi siten, että takaisinperitty tukikuukausi palautuu opiskelijan käytettäväksi..

27 §. _Takaisinperintä_  Pykälän 5 momenttia ehdotetaan muutettavaksi siten, että takaisin perittävälle summalle lasketaan korkolain mukainen  kulloinkin voimassaoleva viivästyskorko kiinteän 15 prosentin korotukset sijasta. Viivästyskorkoa takaisinperittävälle summalle laskettaisiin tulonvalvontavuotta seuraavan vuoden alusta alkaen.

__2. Voimaantulo__

Laki ehdotetaan tulevaksi voimaan 1 päivänä _____kuuta 2012. 

Edellä esitetyn perusteella annetaan Eduskunnan hyväksyttäväksi seuraava lakiehdotus:

Lakiehdotus
===========

__Laki__
__opintotukilain muuttamisesta__

Eduskunnan päätöksen mukaisesti
_muutetaan_ opintotukilain (65/1994) 7 b §:n 3 momentti sekä 27 §:n 5 momentti,
sellaisina kuin ne ovat, 7 b §:n 3 momentti laissa 52/2011, sekä 27 §:n 5 momentti laissa 1099/2000, seuraavasti:


7 b §
_Tukikuukauden käyttäminen_

Takaisinperintä palauttaa tukikuukauden uudelleen käytettäväksi.

27 §
_Takaisinperintä_

Opiskelijan omien tulojen perusteella takaisinperittäväksi määrätyn opintorahan ja asumislisän yhteissummalle lasketaan kulloinkin voimassaolevaa korkolain mukaista viivästyskorkoa.

Tämä laki tulee voimaan päivänä kuuta 20__. 

Ennen lain voimaantuloa voidaan ryhtyä lain toimeenpanon edellyttämiin toimiin.
EOS

[
  {
    title: "Koiraverolain kumoaminen",
    summary: "Koiraverolain kumoaminen",
    body: koiravero_body,    
    state: "draft", author: joonas 
  },
  {
    title: "Opintorahan takaisinperinnän muuttaminen",
    summary: "Opintotukilain muuttaminen siten, että opintorahan ja asumislisän takaisinperintään liittyvän 15 prosentin rangaistusluonteisen korotusmaksu korvataan kulloinkin voimassaolevalla viivästyskorolla sekä takaisinperintää koskevat opintotukikuukaudet palautetaan takaisin opiskelijan käytettäväksi.",
    body: opintotuki_body,    
    state: "draft", author: joonas 
  },
  { title: "Kansanedustajien palkankorotus pannaan",
    summary: "Kansanedustajien palkkaa meinataan nostaa miltei 10%. Se on paljon enemmän kuin TUPO. Ei ole soveliaista sietää semmoista.",
    body: "Ei voida tukea näin suurisuuntaisia ideoita kun ei ole kansalla varaa kuntiinsa!",
    state: "idea", author: random_citizen},
  { title: "Poistetaan perintöverotus",
    summary: "Poistakaa ja ottakaa raha firmoilta ja tasaverolla rikkailta!",
    body: "Ankarin perintövero korvattakoon tasaverolla!",
    state: "draft", author: random_citizen},
  { title: "Raiskauksille kunnon tuomiot",
    summary: "Joku roti!",
    body: "Suuremmat rangaistukset olisivat linjakkaampia!",
    state: "proposal", author: random_citizen},
  { title: "Kaikelle isommat tuomiot",
    summary: "Joku roti!",
    body: "Suuremmat rangaistukset olisivat linjakkaampia!",
    state: "law", author: random_citizen},
  { title: "Vielä isommat tuomiot",
    summary: "Rinta rottingille! Tai rottinkia selkään. Nyt on aika pistää perusrangaistukset kovalle linjalle, ja lopettaa kansan kärsimykset!",
    body: "Suuremmat rangaistukset olisivat linjakkaampia!",
    state: "idea", author: random_citizen},
].each { |idea| i = Idea.create(idea); i.state = idea[:state]; i.author = idea[:author]; i.save! }

20.times do |i|
  idea = Idea.create(
    { title: "Esimerkki-idea #{i}", 
      summary: "Melko tavallisen oloinen esimerkki-idean tiivistelmä, jota ei parane ohittaa olankohautuksella tai saattaa jäädä jotain huomaamatta.", 
      body: "Yleensä esimerkit ovat ytimekkäitä. Joskus ne venyvät syyttä. Tällä kertaa ei käy niin. Oleellista on uniikki sisältö. Tämä idea #{i} on uniikki. Tätä ei ole tässä muodossa missään muualla.",  
      created_at: Time.now - (60*60*24),
      updated_at: Time.now - (60*60*24),
      })
  idea.state = "idea"
  idea.author = random_citizen
  idea.save!
end

voters = (0..100).map do |i|
  Citizen.find_or_create_by_email(
      email: "voter#{i}@voter.com",
      password: "voter#{i}", password_confirmation: "voter#{i}", remember_me: true,
      profile_attributes: {first_names: "Clueless Voter", first_name: "Voter", last_name: "#{i}", name: "Voter #{i}"}
    )
end

Idea.all.each do |idea|
  rand(5).times { Factory(:comment, commentable: idea, author: Citizen.first(offset: rand(Citizen.count))) }
end

voter_count = voters.size

ideas = Idea.find(:all).to_a
# first idea has 0 votes
ideas.shift  
# next ideas have only one for and against
ideas.shift.vote(voters[rand(voter_count)], 0)
ideas.shift.vote(voters[rand(voter_count)], 1)

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
    idea.vote(v, rand(2))
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
      author:       Citizen.find(field(f, "author")),
      idea:         (iid = field(f, "idea").chomp; iid == "" ? nil : Idea.find(iid)),
      title:        field(f, "title"),
      ingress:      field(f, "ingress") && read_till(f),
      body:         field(f, "body") && read_till(f),
    }
    
    Article.find_or_create_by_created_at(article)
  end
end
