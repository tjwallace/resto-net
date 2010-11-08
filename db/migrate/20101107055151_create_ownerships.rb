class CreateOwnerships < ActiveRecord::Migration
  def self.up
    create_table :ownerships do |t|
      t.integer :owner_id
      t.integer :establishment_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :ownerships, :owner_id
    add_index :ownerships, :establishment_id
    add_index :ownerships, [:owner_id, :establishment_id], :unique => true

    add_column :owners, :establishments_count, :integer, :default => 0
    add_column :establishments, :owners_count, :integer, :default => 0
  end

  def self.down
    drop_table :ownerships
    remove_column :owners, :establishments_count
    remove_column :establishments, :owners_count
  end
end
