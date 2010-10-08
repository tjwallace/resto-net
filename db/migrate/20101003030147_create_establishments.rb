class CreateEstablishments < ActiveRecord::Migration
  def self.up
    create_table :establishments do |t|
      t.string :name
      t.string :address
      t.belongs_to :owner
      t.belongs_to :type

      t.timestamps
    end

    add_index :establishments, :type_id
  end

  def self.down
    drop_table :establishments
  end
end
