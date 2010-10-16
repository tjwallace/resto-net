require 'spec_helper'

describe Type do
  it { should have_many(:establishments) }
  it { should validate_presence_of(:name) }

  it "should translate name" do
    t = Type.create :name => 'english'
    t.name.should eq('english')
    I18n.locale = :fr
    t.name = 'french'
    t.name.should eq('french')
    I18n.locale = :en
    t.name.should eq('english')
  end
end
