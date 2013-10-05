class CreatePoliticalParties < ActiveRecord::Migration
  def change
    create_table :political_parties do |t|
      t.string :name

      t.timestamps
    end

    %w(KOK SDP VAS PS RKP KESK KD VIHR SKP).each do |party|
      PoliticalParty.create(:name => party)
    end
  end
end