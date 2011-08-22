class CreateEstablishments < ActiveRecord::Migration
  def self.up
    create_table :establishments do |t|
      t.string :name
      t.string :name_fingerprint
      t.string :address
      t.string :address_fingerprint
      t.string :city
      t.string :city_fingerprint
      t.belongs_to :type
      t.integer :infractions_amount, :default => 0
      t.integer :infractions_count, :default => 0
      t.integer :judgment_span, :default => 0
      t.float :latitude
      t.float :longitude
      t.string :street
      t.string :region
      t.string :locality
      t.string :country
      t.string :postal_code

      t.timestamps
    end

    add_index :establishments, [:name_fingerprint, :address_fingerprint, :city_fingerprint], :unique => true, :name => 'index_establishments_on_fingerprints'
    add_index :establishments, :type_id
  end

  def self.down
    drop_table :establishments
  end
end
