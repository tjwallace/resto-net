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

  describe "find_or_create_by_name" do
    it "should create a new type if it doesn't exist" do
      Type.find_or_create_by_name('foo')
      Type.count.should eq(1)
    end

    it "should find a type if it already exists" do
      type_1 = Type.create(:name => 'bar')
      type_2 = Type.find_or_create_by_name('bar')
      type_1.id.should eq(type_2.id)
      Type.count.should eq(1)
    end
  end
end
