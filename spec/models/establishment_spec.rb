require 'spec_helper'

describe Establishment do
  it { should belong_to(:owner) }
  it { should belong_to(:type) }
  it { should have_many(:infractions) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:owner) }
  it { should validate_presence_of(:type) }

  it "should recognize when it's geocoded" do
    e = Establishment.new :latitude => 1.0, :longitude => 1.0
    e.should be_geocoded
  end
end
