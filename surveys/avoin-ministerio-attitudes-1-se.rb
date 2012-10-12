# encoding: UTF-8
survey "Avoin Ministerio Attitudes 1 se" do

  section "Medborgarinitiativet och politiska förhållningssätt" do
    label "Frågorna berör ditt politiska engagemang och hur denna webbportal inverkar på det.  Anteckna vänligen så noggrant som möjligt de alternativ som bäst beskriver din  uppfattning just nu.  En anonym version av datamaterialet kommer att förvaras vid Finlands samhällsvetenskapliga dataarkiv (http://www.fsd.uta.fi/sv/) således att andra forskare  kan få glädja av materialet. All information behandlas absolut konfidentiellt och dina  personliga upplysningar ges inte vidare till tredje part."

    label "Apuasi arvostetaan kovasti."

    #1
    q "Hur intresserad är Ni av politik?", :pick => :one
    a "Mycket intresserad"
    a "Ganska intresserad"
    a "Inte särskilt intresserad"
    a "Inte alls intresserad"


    #2
    q "Hur ofta verkar politik så komplicerat att Ni inte riktigt förstår vad det handlar om?", :pick => :one
    a "Aldrig"
    a "Sällan"
    a "Ibland"
    a "Ofta"
    a "Alltid"


    #3
    q "Hur svårt eller lätt tycker Ni att det är att ta ställning i politiska frågor?", :pick => :one
    a "Mycket svårt"
    a "Svårt"
    a "Varken svårt eller lätt"
    a "Lätt"
    a "Mycket lätt"


    #4
    grid "Berätta på en skala från noll till tio hur stor tillit Ni personligen har till var och en av följande institutioner. Noll betyder att Ni inte har någon tillit alls till den institutionen, 10 att Ni har full tillit" do
      (0..10).to_a.each{|num| a num.to_s}
      q "Finlands riksdag", :pick => :one, :display_type => :slider
      q "Politikerna", :pick => :one, :display_type => :slider
      q "Politiska partierna", :pick => :one, :display_type => :slider
      q "Republikens president", :pick => :one, :display_type => :slider
      q "Finlands regering (statsrådet)", :pick => :one, :display_type => :slider
    end


    #5
    q "Hur nöjd är Ni med hur demokratin fungerar i Finland?", :pick => :one, :display_type => :slider
    a "Extremt missnöjd"
    (1..9).to_a.each{|num| a num.to_s}
    a "Extremt nöjd"


    #6
    q "Kan möjligheten att lägga fram ett medborgarinitiativ enlig din åsikt medverka till att förbättra den finländska demokratin?", :pick => :one, :display_type => :slider
    a "Medverkar inte alls"
    (1..9).to_a.each{|num| a num.to_s}
    a "Medverkar mycket"

    #7
    q "Skulle Ni säga att man i allmänhet kan lita på de flesta människor eller att man inte kan vara nog försiktig när man har att göra med andra människor. Svara på en skala från 0 till 10, där 0 betyder att man inte kan vara nog försiktig och där 10 betyder att man kan lita på de flesta människor?", :pick => :one, :display_type => :slider
    a "Man kan inte vara försiktig nog"
    (1..9).to_a.each{|num| a num.to_s}
    a "Man kan lita på de flesta människor"

    #8
    q "I politiska sammanhang brukar man ibland tala om 'vänster' och 'höger'. Var skulle Ni placera Er på skalan där noll står för vänstern och tio för högern?", :pick => :one, :display_type => :slider
    a "Vänstern"
    (1..9).to_a.each{|num| a num.to_s}
    a "Högern"

    #9
    q "En del människor röstar inte nuförtiden, av en eller annan anledning. Röstade Ni i det senaste riksdagsvalet i 2011?", :pick => :one
    a "Ja"
    a "Nej"
    a "Ingen rösträtt"


    #10
    q "Det finns olika sätt att försöka förbättra saker i Finland eller att försöka förhindra att saker går fel. Har Ni under de 12 senaste månaderna gjort något av följande", :pick => :any
    a "Skriva insändare"
    a "Ta kontakt med politiska beslutsfattare i ett viktigt ärende"
    a "Delta i ett politiskt partis verksamhet"
    a "Skriva på ett upprop eller en namninsamling"
    a "Delta i annan föreningsverksamhet"
    a "Styra mina inköp så att jag genom mina konsumtionsvanor främjar naturskyddet"
    a "Styra mina inköp så att jag som konsument påverkar samhälleliga eller politiska frågor"
    a "Delta i en bojkott, betalnings- eller köpstrejk"
    a "Delta i en fredlig demonstration"
    a "Uppvisa civil olydnad genom att delta i olaglig direkt aktion"
    a "Delta i sådana demonstrationer där det tidigare har förekommit våld"
    a "Bruka våld för att uppnå politiska mål"


    #11
    q "Ert födelseår", :pick => :one, :display_type => :dropdown
    (1900..1996).to_a.each{|year| a year.to_s}


    #12
    q "Kön", :pick => :one
    a "Man"
    a "Kvinna"


    #13
    q "Hemortskommun", :pick => :one, :display_type => :dropdown
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
    q "Vilken är Er utbildning. Välj den högsta utbildningsnivån, som Ni slutfört?", :pick => :one
    a "Mindre än grundskolans lågstadium eller mindre än folkskola"
    a "Grundskolans lågstadium (årskurserna 1-6), folkskola"
    a "Grundskolans högstadium (årskurserna 7-9/10), mellanskola"
    a "Gymnasium, student- eller yrkesexamen"
    a "Examen på institutnivå eller högskoleexamen"
    a "Licentiat- eller doktorsexamen"



    #15
    q "Hur stora är Ert hushålls sammanlagda bruttoinkomster per år? (Inkomster före skatt, inklusive skattepliktiga socialförmåner)?"
    a "|euro per år", :integer
    validation :rule => "A and B"
    condition_A ">=", :integer_value => 0
    condition_B "<=", :integer_value => 9999999


    #16
    q "Vilken samhällsklass anser Ni Er tillhöra?", :pick => :one
    a "Arbetarklass"
    a "Lägre medelklass"
    a "Medelklass"
    a "Övre medelklass"
    a "Överklass"
    a "Jag tillhör ingen samhällsklass"


    #17
    q "Civilstånd", :pick => :one
    a "Ogift"
    a "Gift eller i annat registrerat partnerskap"
    a "Sambo"
    a "Skild eller i hemskillnad"
    a "Änka/änkling"
    a "Annat"


    #18
    q "Modersmål", :pick => :one
    a "Finska"
    a "Svenska"
    a "Annat språk, vilket?", :string


    #19
    q "Bor Ni i", :pick => :one
    a "Centrum av en stad"
    a "En förstad eller förort"
    a "Kommuncentrum eller annan tätort"
    a "Glesbygden"


  end

end
