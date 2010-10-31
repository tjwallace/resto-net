class CreateEstablishments < ActiveRecord::Migration
  def self.up
    create_table :establishments do |t|
      t.string :name
      t.string :address
      t.belongs_to :type
      t.integer :infractions_amount, :default => 0

      t.float :latitude
      t.float :longitude
      t.string :street
      t.string :region
      t.string :locality
      t.string :country
      t.string :postal_code

      t.timestamps
    end

    add_index :establishments, :name, :unique => true
    add_index :establishments, :type_id
  end

  def self.down
    drop_table :establishments
  end
end
