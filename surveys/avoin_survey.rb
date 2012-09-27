# encoding: UTF-8
survey "Avion Survey" do


  #1
  q "Kuinka kiinnostunut olette politiikasta", :pick => :one
  a "Erittäin kiinnostunut"
  a "Melko kiinnostunut"
  a "Ette kovin kiinnostunut"
  a "Ette lainkaan kiinnostunut?"


  #2
  q "Kuinka usein Teistä tuntuu siltä, että politiikka on niin monimutkaista, että ette oikein ymmärrä, mistä on kyse?"
  a "Ei koskaan"
  a "Harvoin"
  a "Joskus" 	
  a "Toisinaan"
  a "Usein" 	


  #3
  q "Kuinka vaikeaa tai helppoa Teidän on muodostaa mielipiteenne politiikkaa koskevista kysymyksistä?"
  a "Erittäin vaikeaa"
  a "Vaikeaa"
  a "Ei vaikeaa eikä helppoa"
  a "Helppoa"
  a "Erittäin helppoa"


  #4
  q "Kertokaa asteikolla nollasta kymmeneen, kuinka paljon henkilökohtaisesti luotatte seuraavaksi luettelemiini tahoihin. Nolla tarkoittaa sitä, että ette luota ollenkaan kyseiseen tahoon ja 10 sitä, että luotatte erittäin vahvasti kyseiseen tahoon:"
  label "Eduskunta?"
  (1..10).to_a.each{|num| a num.to_s}
  label "Poliitikot?"
  (1..10).to_a.each{|num| a num.to_s}
  label "Poliittiset puolueet?"
  (1..10).to_a.each{|num| a num.to_s}
  label "Tasavallan presidentti"
  (1..10).to_a.each{|num| a num.to_s}
  label "Suomen hallitus (valtioneuvosto)"
  (1..10).to_a.each{|num| a num.to_s}


  #5
  q "Kuinka tyytyväinen olette siihen, kuinka demokratia toimii Suomessa?"
  a "ÄÄRIMMÄISEN TYYTYMÄTÖN"
  (2..8).to_a.each{|num| a num.to_s}
  a "ÄRIMMÄISEN TYYTYVÄINEN"


  #6
  q "Auttaako mahdollisuus kansalaisaloitteen tekemiseen mielestänne kehittämään suomalaista demokratiaa?  "
  a "Ei auta lainkaan"
  (2..8).to_a.each{|num| a num.to_s}
  a "Auttaa erittäin paljon"

  #7
  q "Voiko mielestänne ihmisiin luottaa, vai onko niin, ettei ihmisten suhteen voi olla liian varovainen. Kertokaa mielipiteenne asteikolla nollasta kymmeneen, jossa nolla tarkoittaa, ettei ihmisten kanssa voi olla liian varovainen ja 10, että useimpiin ihmisiin voi luottaa?"
  a "EI VOI OLLA LIIAN VAROVAINEN"
  (2..8).to_a.each{|num| a num.to_s}
  a "USEIMPIIN IHMISIIN VOI LUOTTAA"

  #8
  q "Politiikassa puhutaan joskus vasemmistosta ja oikeistosta. Mihin kohtaan sijoittaisitte itsenne asteikolla nollasta kymmeneen, kun nolla tarkoittaa vasemmistoa ja kymmenen oikeistoa?"
  a "VASEMMISTO"
  (2..8).to_a.each{|num| a num.to_s}
  a "OIKEISTO"


  #9
  q "On olemassa erilaisia keinoja parantaa Suomen asioita tai estää asioiden kehittymistä huonoon suuntaan. Oletteko viimeisten 12 kuukauden aikana tehnyt mitään seuraavista Kirjoittaa yleisönosastoon"
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


  #9
  q "Syntymävuotenne"
  a :date


  #10
  q "Sukupuoli"
  a "Mies"
  a "Nainen"


  #11
  q "Mikä on peruskoulutuksenne?"
  a "Peruskoulun luokat 1-6, kansakoulu"
  a "Peruskoulun luokat 7-9, 10, keskikoulu"
  a "Vielä koulussa (peruskoulu, lukio)"
  a "Ylioppilas, lukio"	
  a "Ei muodollista peruskoulutusta"



  #12
  q "Mikä on ammatillinen koulutuksenne?"
  a "Vielä koulussa (ammattikoulu-, -kurssi)"
  a "Lyhyt ammatillinen koulutus (ammattikoulu, -kurssi)"
  a "Opistoasteen ammatillinen tutkinto"	
  a "Jonkin verran ammattikorkeakoulu- tai yliopisto-opintoja"
  a "Ammattikorkeakoulututkinto"	
  a "Yliopistotutkinto"	
  a "Ei muodollista ammatillista koulutusta"


  #13
  q "Kuinka suuret ovat keskimäärin kotitaloutenne yhteenlasketut vuositulot veroja vähentämättä ( = bruttotulot) mukaan laskien veronalaiset sosiaalietuudet?" 
  a "euroa vuodessa", :integer


  #14
  q "Mihin yhteiskuntaluokkaan katsotte lähinnä kuuluvanne?"
  a "Työväenluokka"
  a "Alempi keskiluokka"
  a "Keskiluokka"
  a "Ylempi keskiluokka"
  a "Yläluokka"
  a "En mihinkään luokkaan"


  #15
  q "Siviilisäätynne"
  a "Naimaton"
  a "Avioliitossa tai muussa rekisteröidyssä parisuhteessa"
  a "Avoliitossa"
  a "Eronnut tai asumuserossa"
  a "Leski"
  a "Muu"


  #16
  q "Äidinkieli"
  a "Suomi"
  a "Ruotsi"
  a "Jokin muu kieli, mikä?", :string


  #17
  q "Asutteko"
  a "Kaupungin keskustassa"
  a "Esikaupunkialueella tai kaupunkilähiössä"
  a "Kuntakeskuksessa tai muussa taajamassa"
  a "Maaseudun haja-asutusalueella?"


end
