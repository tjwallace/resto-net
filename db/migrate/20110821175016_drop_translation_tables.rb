class DropTranslationTables < ActiveRecord::Migration
  def self.up
    Infraction.drop_translation_table!
    Type.drop_translation_table!
  end

  def self.down
    Infraction.create_translation_table! :description => :text
    Type.create_translation_table! :name => :string
  end
end
