require 'spec_helper'

describe Infraction do
  it { should belong_to(:establishment) }

  %w(establishment amount infraction_date judgment_date).each do |attr|
    it { should validate_presence_of(attr) }
  end
  it { should validate_numericality_of(:amount) }
  [-1, 1.1].each do |value|
    it { should_not allow_value(value).for(:amount) }
  end
  [1, 100, 1000].each do |value|
    it { should allow_value(value).for(:amount) }
  end

  it "should translate description" do
    i = Infraction.create :description => 'english', :amount => 1
    i.description.should eq('english')
    I18n.locale = :fr
    i.description = 'french'
    i.description.should eq('french')
    I18n.locale = :en
    i.description.should eq('english')
  end
end
