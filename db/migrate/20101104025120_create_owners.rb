class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.string :name
      t.integer :infractions_count, :default => 0

      t.timestamps
    end

    add_column :infractions, :owner_id, :integer
    add_index :infractions, :owner_id
  end

  def self.down
    drop_table :owners
    remove_column :infractions, :owner_id
    remove_index :infractions, :owner_id
  end
end
