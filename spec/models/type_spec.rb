require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Type do
  it { should have_many(:establishments) }
  it { should validate_presence_of(:name) }

  describe "find_or_create_by_name" do
    subject { Type.find_or_create_by_name('foo') }

    it "creates a new type if it doesn't exist" do
      # subject is lazy loaded
      subject.class.count.should == 1
    end

    it "finds a type if it already exists" do
      subject.id.should == Type.find_or_create_by_name('foo').id
      Type.count.should == 1
    end
  end
end
