class AddJudgmentSpanToEstablishments < ActiveRecord::Migration
  def self.up
    add_column :establishments, :judgment_span, :integer
  end

  def self.down
    remove_column :establishments, :judgment_span
  end
end
