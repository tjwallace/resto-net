class CreateInfractions < ActiveRecord::Migration
  def self.up
    create_table :infractions do |t|
      t.belongs_to :establishment
      t.integer :amount
      t.date :infraction_date
      t.date :judgment_date

      t.timestamps
    end
    Infraction.create_translation_table! :description => :text
  end

  def self.down
    drop_table :infractions
    Infraction.drop_translation_table!
  end
end
