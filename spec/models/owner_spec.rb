require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Owner do
  it { should have_many(:infractions) }
  it { should have_many(:establishments).through(:infractions) }
  it { should validate_presence_of(:name) }
end
