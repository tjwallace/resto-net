# encoding: utf-8
require 'spec_helper'

describe Establishment do
  subject { Factory.create :establishment }

  it { should belong_to(:type) }
  it { should have_many(:infractions).dependent(:destroy) }
  it { should have_many(:ownerships) }
  it { should have_many(:owners).through(:ownerships) }

  %w(name address type).each do |attr|
    it { should validate_presence_of(attr) }
  end
  it { should validate_uniqueness_of(:name) }

  describe "geocode" do
    subject { Factory.build :establishment }

    it "should geocode a good address" do
      subject.update_attribute :address, "839 Rue Sherbrooke Ouest, Montréal, Québec"

      #subject.latitude.should be_within(0.00001).of(45.5039069)
      #subject.longitude.should be_within(0.00001).of(-73.5745631)
      subject.latitude.should be_close(45.5039060, 0.00001)
      subject.longitude.should be_close(-73.5745631, 0.00001)

      subject.street.should == "839 Rue Sherbrooke Ouest"
      subject.locality.should == "Montréal"
      subject.region.should == "QC"
      subject.postal_code.should == "H3A 2K6"
      subject.country.should == "CA"
    end

    it "should not geocode a bad address" do
      subject.update_attribute :address, "try and geocode this google!"
      subject.should_not be_geocoded
    end

    it "should recognize when it's geocoded" do
      subject.should_not be_geocoded
      subject.attributes = { :latitude => 1.0, :longitude => 1.0 }
      subject.should be_geocoded
    end
  end

  describe "#infractions_amount" do
    before(:each) do
      @owner = Factory.create :owner
    end

    it "returns 0 for no infractions" do
      subject.infractions_amount.should == 0
    end

    it "returns the sum of its infraction amounts" do
      3.times do
        subject.infractions.create Factory.attributes_for(:infraction).merge(:owner_id => @owner.id)
      end
      subject.reload # since subject is cached
      subject.infractions_count.should == 3
      subject.infractions_amount.should == subject.infractions.sum(:amount)
    end

    it "recalculates after infraction removal" do
      3.times do
        subject.infractions.create Factory.attributes_for(:infraction).merge(:owner_id => @owner.id)
      end
      subject.infractions.first.destroy
      subject.reload # since subject is cached
      subject.infractions_count.should == 2
      subject.infractions_amount.should == subject.infractions.sum(:amount)
    end
  end
end
