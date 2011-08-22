class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.string :name
      t.integer :infractions_count, :default => 0

      t.timestamps
    end

  end

  def self.down
    drop_table :owners
  end
end
