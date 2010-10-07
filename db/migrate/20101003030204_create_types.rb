class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
      t.timestamps
    end
    Type.create_translation_table! :name => :string
  end

  def self.down
    drop_table :types
    Type.drop_translation_table!
  end
end
