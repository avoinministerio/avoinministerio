# encoding: UTF-8
survey "Avoin Ministerio Attitudes 1 fi" do

  section "Tutkimus: Kansalaisaloite ja asenteet politiikkaa kohtaan" do
    label "Kysymykset koskevat kiinnostustasi politiikkaa kohtaan ja sitä, kuinka Avoimen ministeriön palvelu vaikuttaa siihen. Valitse vaihtoehdoista se, joka kuvaa parhaiten tunteitasi tällä hetkellä. Pyydämme ystävällisesti vastaamaan kysymyksiin niin tarkasti kuin mahdollista. Vastaukset tallennetaan anonyymeinä Yhteiskuntatieteelliseen tietoarkistoon muiden tutkijoiden käytettäväksi. Tietoja käsitellään täysin luottamuksellisesti eikä henkilötietojasi luovuteta kolmansille osapuolille."

    label "Apuasi arvostetaan kovasti."

    #1
    q "Kuinka kiinnostunut olette politiikasta?", :pick => :one
    a "Hyvin kiinnostunut"
    a "Jonkin verran kiinnostunut"
    a "Vain vähän kiinnostunut"
    a "En lainkaan kiinnostunut"


    #2
    q "Kuinka usein Teistä tuntuu siltä, että politiikka on niin monimutkaista, että ette oikein ymmärrä, mistä on kyse?", :pick => :one
    a "Ei koskaan"
    a "Harvoin"
    a "Joskus"
    a "Aina"
    a "Usein"


    #3
    q "Kuinka vaikeaa tai helppoa Teidän on muodostaa mielipiteenne politiikkaa koskevista kysymyksistä?", :pick => :one
    a "Erittäin vaikeaa"
    a "Vaikeaa"
    a "Ei vaikeaa eikä helppoa"
    a "Helppoa"
    a "Erittäin helppoa"


    #4
    grid "Kuinka paljon luotatte seuraaviin tahoihin? (0 = ei ollenkaan, 10 = erittäin vahvasti)" do
      (0..10).to_a.each{|num| a num.to_s}
      q "Eduskunta", :pick => :one, :display_type => :slider
      q "Poliitikot", :pick => :one, :display_type => :slider
      q "Poliittiset puolueet", :pick => :one, :display_type => :slider
      q "Tasavallan presidentti", :pick => :one, :display_type => :slider
      q "Suomen hallitus (valtioneuvosto)", :pick => :one, :display_type => :slider
    end


    #5
    q "Kuinka tyytyväinen olette siihen, kuinka demokratia toimii Suomessa?", :pick => :one, :display_type => :slider
    a "ÄÄRIMMÄISEN TYYTYMÄTÖN"
    (1..9).to_a.each{|num| a num.to_s}
    a "ÄÄRIMMÄISEN TYYTYVÄINEN"


    #6
    q "Auttaako mahdollisuus kansalaisaloitteen tekemiseen mielestänne kehittämään suomalaista demokratiaa?  ", :pick => :one, :display_type => :slider
    a "EI AUTA LAINKAAN"
    (1..9).to_a.each{|num| a num.to_s}
    a "AUTTAA ERITTÄIN PALJON"

    #7
    q "Voiko mielestänne ihmisiin luottaa, vai onko niin, ettei ihmisten suhteen voi olla liian varovainen. Kertokaa mielipiteenne asteikolla nollasta kymmeneen, jossa nolla tarkoittaa, ettei ihmisten kanssa voi olla liian varovainen ja 10, että useimpiin ihmisiin voi luottaa?", :pick => :one, :display_type => :slider
    a "EI VOI OLLA LIIAN VAROVAINEN"
    (1..9).to_a.each{|num| a num.to_s}
    a "USEIMPIIN IHMISIIN VOI LUOTTAA"

    #8
    q "Politiikassa puhutaan joskus vasemmistosta ja oikeistosta. Mihin kohtaan sijoittaisitte itsenne asteikolla nollasta kymmeneen, kun nolla tarkoittaa vasemmistoa ja kymmenen oikeistoa?", :pick => :one, :display_type => :slider
    a "VASEMMISTO"
    (1..9).to_a.each{|num| a num.to_s}
    a "OIKEISTO"

    #9
    q "Jotkut ihmiset jättävät syystä tai toisesta äänestämättä. Äänestittekö Te viime eduskuntavaaleissa 2011?", :pick => :one
    a "Kyllä"
    a "En"
    a "Ei äänioikeutettu"


    #10
    q "On olemassa erilaisia keinoja parantaa Suomen asioita tai estää asioiden kehittymistä huonoon suuntaan. Oletteko viimeisten 12 kuukauden aikana tehnyt mitään seuraavista", :pick => :any
    a "Kirjoittaa yleisönosastoon"
    a "Ottaa yhteyttä poliittisiin päätöksentekijöihin jossakin tärkeässä asiassa"
    a "Kirjoittaa nimenne vetoomuksiin tai nimenkeräyksiin"
    a "Osallistua poliittisen puolueen toimintaan"
    a "Osallistua muun järjestön toimintaan"
    a "Tehdä omia ostopäätöksiäni siten, että voisin kulutustavoillani edistää luonnon suojelua"
    a "Tehdä omia ostopäätöksiäni siten, että voisin kuluttajana vaikuttaa yhteiskunnallisiin tai poliittisiin asioihin"
    a "Osallistua boikottiin, maksu- tai ostolakkoon"
    a "Osallistua rauhanomaisiin mielenosoituksiin"
    a "Osoittaa kansalaistottelemattomuutta osallistumalla väkivallattomaan laittomaan toimintaan"
    a "Osallistua sellaisiin mielenosoituksiin, joissa aiemmin on ilmennyt väkivaltaa"
    a "Käyttää väkivaltaa poliittisten päämäärien saavuttamiseksi"


    #11
    q "Syntymävuotenne", :pick => :one, :display_type => :dropdown
    (1900..1996).to_a.each{|year| a year.to_s}


    #12
    q "Sukupuoli", :pick => :one
    a "Mies"
    a "Nainen"


    #13
    q "Kotikunta", :pick => :one, :display_type => :dropdown
    [ "Alajärvi", "Alavieska", "Alavus", "Asikkala", "Askola", "Aura", "Akaa",
      "Brändö", "Eckerö", "Enonkoski", "Enontekiö", "Espoo", "Eura",
      "Eurajoki", "Evijärvi", "Finström", "Forssa", "Föglö", "Geta",
      "Haapajärvi", "Haapavesi", "Hailuoto", "Halsua", "Hamina", "Hammarland",
      "Hankasalmi", "Hanko", "Harjavalta", "Hartola", "Hattula", "Haukipudas",
      "Hausjärvi", "Heinävesi", "Helsinki", "Vantaa", "Hirvensalmi", "Hollola",
      "Honkajoki", "Huittinen", "Humppila", "Hyrynsalmi", "Hyvinkää",
      "Hämeenkyrö", "Hämeenlinna", "Heinola", "Ii", "Iisalmi", "Iitti",
      "Ikaalinen", "Ilmajoki", "Ilomantsi", "Inari", "Inkoo", "Isojoki",
      "Isokyrö", "Imatra", "Jalasjärvi", "Janakkala", "Joensuu", "Jokioinen",
      "Jomala", "Joroinen", "Joutsa", "Juankoski", "Juuka", "Juupajoki",
      "Juva", "Jyväskylä", "Jämijärvi", "Jämsä", "Järvenpää", "Kaarina",
      "Kaavi", "Kajaani", "Kalajoki", "Kangasala", "Kangasniemi", "Kankaanpää",
      "Kannonkoski", "Kannus", "Karijoki", "Karjalohja", "Karkkila",
      "Karstula", "Karvia", "Kaskinen", "Kauhajoki", "Kauhava", "Kauniainen",
      "Kaustinen", "Keitele", "Kemi", "Keminmaa", "Kempele", "Kerava",
      "Kerimäki", "Kesälahti", "Keuruu", "Kihniö", "Kiikoinen", "Kiiminki",
      "Kinnula", "Kirkkonummi", "Kitee", "Kittilä", "Kiuruvesi", "Kivijärvi",
      "Kokemäki", "Kokkola", "Kolari", "Konnevesi", "Kontiolahti", "Korsnäs",
      "Hämeenkoski", "Koski Tl", "Kotka", "Kouvola", "Kristiinankaupunki",
      "Kruunupyy", "Kuhmo", "Kuhmoinen", "Kumlinge", "Kuopio", "Kuortane",
      "Kurikka", "Kustavi", "Kuusamo", "Outokumpu", "Kyyjärvi", "Kärkölä",
      "Kärsämäki", "Kökar", "Köyliö", "Kemijärvi", "Kemiönsaari", "Lahti",
      "Laihia", "Laitila", "Lapinlahti", "Lappajärvi", "Lappeenranta",
      "Lapinjärvi", "Lapua", "Laukaa", "Lavia", "Lemi", "Lemland", "Lempäälä",
      "Leppävirta", "Lestijärvi", "Lieksa", "Lieto", "Liminka", "Liperi",
      "Loimaa", "Loppi", "Loviisa", "Luhanka", "Lumijoki", "Lumparland",
      "Luoto", "Luumäki", "Luvia", "Lohja", "Länsi-Turunmaa", "Maalahti",
      "Maaninka", "Maarianhamina", "Marttila", "Masku", "Merijärvi",
      "Merikarvia", "Miehikkälä", "Mikkeli", "Muhos", "Multia", "Muonio",
      "Mustasaari", "Muurame", "Mynämäki", "Myrskylä", "Mäntsälä",
      "Mäntyharju", "Mänttä-Vilppula", "Naantali", "Nakkila", "Nastola",
      "Nilsiä", "Nivala", "Nokia", "Nousiainen", "Nummi-Pusula", "Nurmes",
      "Nurmijärvi", "Närpiö", "Orimattila", "Oripää", "Orivesi", "Oulainen",
      "Oulu", "Oulunsalo", "Padasjoki", "Paimio", "Paltamo", "Parikkala",
      "Parkano", "Pelkosenniemi", "Perho", "Pertunmaa", "Petäjävesi",
      "Pieksämäki", "Pielavesi", "Pietarsaari", "Pedersören kunta",
      "Pihtipudas", "Pirkkala", "Polvijärvi", "Pomarkku", "Pori", "Pornainen",
      "Posio", "Pudasjärvi", "Pukkila", "Punkaharju", "Punkalaidun",
      "Puolanka", "Puumala", "Pyhtää", "Pyhäjoki", "Pyhäjärvi", "Pyhäntä",
      "Pyhäranta", "Pälkäne", "Pöytyä", "Porvoo", "Raahe", "Raisio",
      "Rantasalmi", "Ranua", "Rauma", "Rautalampi", "Rautavaara", "Rautjärvi",
      "Reisjärvi", "Riihimäki", "Ristiina", "Ristijärvi", "Rovaniemi",
      "Ruokolahti", "Ruovesi", "Rusko", "Rääkkylä", "Raasepori", "Saarijärvi",
      "Salla", "Salo", "Saltvik", "Sauvo", "Savitaipale", "Savonlinna",
      "Savukoski", "Seinäjoki", "Sievi", "Siikainen", "Siikajoki",
      "Siilinjärvi", "Simo", "Sipoo", "Siuntio", "Sodankylä", "Soini",
      "Somero", "Sonkajärvi", "Sotkamo", "Sottunga", "Sulkava", "Sund",
      "Suomenniemi", "Suomussalmi", "Suonenjoki", "Sysmä", "Säkylä", "Vaala",
      "Sastamala", "Siikalatva", "Taipalsaari", "Taivalkoski", "Taivassalo",
      "Tammela", "Tampere", "Tarvasjoki", "Tervo", "Tervola", "Teuva",
      "Tohmajärvi", "Toholampi", "Toivakka", "Tornio", "Turku", "Pello",
      "Tuusniemi", "Tuusula", "Tyrnävä", "Töysä", "Ulvila", "Urjala",
      "Utajärvi", "Utsjoki", "Uurainen", "Uusikaarlepyy", "Uusikaupunki",
      "Vaasa", "Valkeakoski", "Valtimo", "Varkaus", "Vehmaa", "Vesanto",
      "Vesilahti", "Veteli", "Vieremä", "Vihanti", "Vihti", "Viitasaari",
      "Vimpeli", "Virolahti", "Virrat", "Vårdö", "Vähäkyrö", "Vöyri", "Yli-Ii",
      "Ylitornio", "Ylivieska", "Ylöjärvi", "Ypäjä", "Ähtäri", "Äänekoski",
      "Ulkomaat" ].each{ |county| a county}



    #14
    q "Mikä on koulutuksenne? Valitkaa korkein koulutusaste, jonka olette suorittanut.", :pick => :one
    a "Vähemmän kuin peruskoulun ala-aste tai vähemmän kuin kansakoulu"
    a "Peruskoulun ala-aste (1-6 luokat), kansakoulu"
    a "Peruskoulun yläaste (7-9/10 luokat), keskikoulu"
    a "Lukio, ylioppilas- tai ammatillinen tutkinto"
    a "Opisto- tai korkeakoulututkinto"
    a "Lisensiaatin tai tohtorin tutkinto"



    #15
    q "Kuinka suuret ovat keskimäärin kotitaloutenne yhteenlasketut vuositulot veroja vähentämättä ( = bruttotulot) mukaan laskien veronalaiset sosiaalietuudet?"
    a "|euroa vuodessa", :integer
    validation :rule => "A and B"
    condition_A ">=", :integer_value => 0
    condition_B "<=", :integer_value => 9999999


    #16
    q "Mihin yhteiskuntaluokkaan katsotte kuuluvanne?", :pick => :one
    a "Työväenluokka"
    a "Alempi keskiluokka"
    a "Keskiluokka"
    a "Ylempi keskiluokka"
    a "Yläluokka"
    a "En mihinkään luokkaan"


    #17
    q "Siviilisäätynne", :pick => :one
    a "Naimaton"
    a "Avioliitossa tai muussa rekisteröidyssä parisuhteessa"
    a "Avoliitossa"
    a "Eronnut tai asumuserossa"
    a "Leski"
    a "Muu"


    #18
    q "Äidinkieli", :pick => :one
    a "Suomi"
    a "Ruotsi"
    a "Jokin muu kieli, mikä?", :string


    #19
    q "Asutteko", :pick => :one
    a "Kaupungin keskustassa"
    a "Esikaupunkialueella tai kaupunkilähiössä"
    a "Kuntakeskuksessa tai muussa taajamassa"
    a "Maaseudun haja-asutusalueella?"


  end

end
