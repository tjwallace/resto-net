# encoding: utf-8
require 'spec_helper'

describe Establishment do
  it { should belong_to(:owner) }
  it { should belong_to(:type) }
  it { should have_many(:infractions).dependent(:destroy) }

  %w(name address owner type).each do |attr|
    it { should validate_presence_of(attr) }
  end

  describe "geocode" do
    before(:each) do
      @e = Factory.build :establishment
    end

    it "should geocode a good address" do
      @e.address = "839 Rue Sherbrooke Ouest, Montréal, Québec" # McGill
      @e.save
      # for rspec 2.0.1
      #@e.latitude.should be_within(0.00001).of(45.5039069)
      #@e.longitude.should be_within(0.00001).of(-73.5745631)
      @e.latitude.should be_close(45.5039060, 0.00001)
      @e.longitude.should be_close(-73.5745631, 0.00001)
      @e.street.should == "839 Rue Sherbrooke Ouest"
      @e.locality.should == "Montréal"
      @e.region.should == "QC"
      @e.postal_code.should == "H3A 2K6"
      @e.country.should == "CA"
    end

    it "should not geocode a bad address" do
      @e.address = "try and geocode this google!"
      @e.save
      @e.should_not be_geocoded
    end

    it "should recognize when it's geocoded" do
      @e.should_not be_geocoded
      @e.attributes = { :latitude => 1.0, :longitude => 1.0 }
      @e.should be_geocoded
    end
  end

  describe "total_infractions_amount" do
    before(:each) do
      @e = Factory.create :establishment
    end

    it "should return 0 for no infractions" do
      @e.infractions.count.should == 0
      @e.total_infractions_amount.should == 0
    end

    it "should return the sum of the infractions amount" do
      total = 3.times.map{ @e.infractions.create(Factory.attributes_for :infraction).amount }.sum
      @e.total_infractions_amount.should == total
    end
  end
end
