class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.string :name
      t.string :name_fingerprint
      t.integer :infractions_count, :default => 0

      t.timestamps
    end

    add_index :owners, :name_fingerprint, :unique => true
  end

  def self.down
    drop_table :owners
  end
end
