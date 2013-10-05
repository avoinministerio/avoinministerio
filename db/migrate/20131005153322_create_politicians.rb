#encoding: UTF-8
class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.integer :political_party_id
      t.integer :city_id
      t.string :name

      t.timestamps
    end

    add_index :politicians, :city_id
    add_index :politicians, :political_party_id

    # create politician records
    politicians = { :KOK => [ { :id => 101, :name => "Andersson Hennariikka" },
        { :id => 102, :name => "Asko-Seljavaara Sirpa" },
        { :id => 103, :name => "Bogomoloff Harry" },
        { :id => 104, :name => "Enroth Matti" },
        { :id => 105, :name => "Hakola Juha" },
        { :id => 106, :name => "Karhuvaara Arja" },
        { :id => 107, :name => "Koskinen Kauko" },
        { :id => 108, :name => "Koulumies Terhi" },
        { :id => 109, :name => "Majuri Pekka" },
        { :id => 110, :name => "Muurinen Seija" },
        { :id => 111, :name => "Männistö Lasse" },
        { :id => 112, :name => "Nieminen Jarmo" },
        { :id => 113, :name => "Niiranen Matti" },
        { :id => 114, :name => "Pakarinen Pia" },
        { :id => 115, :name => "Pelkonen Jaana" },
        { :id => 116, :name => "Raittinen Timo" },
        { :id => 117, :name => "Rauhamäki Tatu" },
        { :id => 118, :name => "Rautava Risto" },
        { :id => 119, :name => "Rissanen Laura" },
        { :id => 120, :name => "Rydman Wille" },
        { :id => 121, :name => "Urho Ulla-Marja" },
        { :id => 122, :name => "Vapaavuori Jan" } ],
      :SDP => [ { :id => 123, :name => "Anttila Maija" },
        { :id => 124, :name => "Arajärvi Pentti" },
        { :id => 125, :name => "Heinäluoma Eero" },
        { :id => 126, :name => "Jalovaara Ville" },
        { :id => 127, :name => "Järvinen Jukka" },
        { :id => 128, :name => "Lipponen Päivi" },
        { :id => 129, :name => "Mäki Terhi" },
        { :id => 130, :name => "Paavolainen Sara" },
        { :id => 131, :name => "Pajamäki Osku" },
        { :id => 132, :name => "Razmyar Nasima" },
        { :id => 133, :name => "Taipale Ilkka" },
        { :id => 134, :name => "Tenkula Tarja" },
        { :id => 135, :name => "Torsti Pilvi" },
        { :id => 136, :name => "Wallgren Thomas" },
        { :id => 137, :name => "Valokainen Tuomo" } ],
      :VAS => [ { :id => 138, :name => "Arhinmäki Paavo" },
        { :id => 139, :name => "Honkasalo Veronika" },
        { :id => 140, :name => "Koivulaakso Dan" },
        { :id => 141, :name => "Loukoila Eija" },
        { :id => 142, :name => "Modig Silvia" },
        { :id => 143, :name => "Muttilainen Sami" },
        { :id => 144, :name => "Puhakka Sirpa" },
        { :id => 145, :name => "Saarnio Pekka" },
        { :id => 146, :name => "Vuorjoki Anna" } ],
      :PS =>  [ { :id => 147, :name => "Halla-aho Jussi" },
        { :id => 148, :name => "Hursti René" },
        { :id => 149, :name => "Huru Nina" },
        { :id => 150, :name => "Kanerva Seppo" },
        { :id => 151, :name => "Kantola Helena" },
        { :id => 152, :name => "Lindell Harri" },
        { :id => 153, :name => "Packalén Tom" },
        { :id => 154, :name => "Raatikainen Mika" } ],
      :RKP => [ { :id => 155, :name => "Brettschneider Gunvor" },
        { :id => 156, :name => "Månsson Björn" },
        { :id => 157, :name => "Rantala Marcus" },
        { :id => 158, :name => "Storgård Päivi" },
        { :id => 159, :name => "Thors Astrid" } ],
      :KESK => [{ :id => 160, :name => "Kolbe Laura" },
        { :id => 161, :name => "Laaninen Timo" },
        { :id => 162, :name => "Peltokorpi Terhi" } ],
      :KD =>  [ { :id => 163, :name => "Ebeling Mika" },
        { :id => 164, :name => "Mäkimattila Sari" } ],
      :VIHR => [{ :id => 166, :name => "Abdulla Zahra" },
        { :id => 167, :name => "Alanko-Kahiluoto Outi" },
        { :id => 168, :name => "Chydenius Jussi" },
        { :id => 169, :name => "Hamid Jasmin" },
        { :id => 170, :name => "Hautala Heidi" },
        { :id => 171, :name => "Holopainen Mari" },
        { :id => 172, :name => "Ikävalko Suzan" },
        { :id => 173, :name => "Kari Emma" },
        { :id => 174, :name => "Kivekäs Otso" },
        { :id => 175, :name => "Kousa Tuuli" },
        { :id => 176, :name => "Krohn Minerva" },
        { :id => 177, :name => "Oskala Hannu" },
        { :id => 178, :name => "Perälä Erkki" },
        { :id => 179, :name => "Puoskari Mari" },
        { :id => 180, :name => "Relander Jukka" },
        { :id => 181, :name => "Sinnemäki Anni" },
        { :id => 182, :name => "Soininvaara Osmo" },
        { :id => 183, :name => "Stranius Leo" },
        { :id => 184, :name => "Sumuvuori Johanna" } ],
      :SKP => [ { :id => 165, :name => "Hakanen Yrjö" } ] }

    region = Region.find_by_name("Southern Finland")
    cities = region.cities

    PoliticalParty.find_each do |party|
      politicians[party.name.to_sym].each do |politician_hash|
        party.politicians.create(:name => politician_hash[:name], :city_id => cities.sample.id)
      end
    end
  end
end
