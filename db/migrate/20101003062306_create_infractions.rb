class CreateInfractions < ActiveRecord::Migration
  def self.up
    create_table :infractions do |t|
      t.belongs_to :establishment
      t.text :description
      t.integer :amount
      t.date :infraction_date
      t.date :jugement_date

      t.timestamps
    end
  end

  def self.down
    drop_table :infractions
  end
end
