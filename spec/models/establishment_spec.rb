require 'spec_helper'

describe Establishment do
  it { should belong_to(:owner) }
  it { should belong_to(:type) }
  it { should have_many(:infractions) }

  %w(name address owner type).each do |attr|
    it { should validate_presence_of(attr) }
  end

  it "should recognize when it's geocoded" do
    e = Establishment.new
    e.should_not be_geocoded
    e.attributes = { :latitude => 1.0, :longitude => 1.0 }
    e.should be_geocoded
  end
end
