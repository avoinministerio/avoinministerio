class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.references  :citizen
      t.references  :idea
      t.string      :idea_title
      t.date        :idea_date
      t.string      :fullname
      t.date        :birth_date
      t.string      :occupancy_county
      t.boolean     :vow
      t.date        :signing_date
      t.string      :state

      t.timestamps
    end
  end
end
