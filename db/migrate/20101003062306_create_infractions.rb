class CreateInfractions < ActiveRecord::Migration
  def self.up
    create_table :infractions do |t|
      t.belongs_to :owner
      t.belongs_to :establishment
      t.text :description
      t.integer :amount
      t.date :infraction_date
      t.date :judgment_date

      t.timestamps
    end

    add_index :infractions, :owner_id
    add_index :infractions, :establishment_id
  end

  def self.down
    drop_table :infractions
  end
end
