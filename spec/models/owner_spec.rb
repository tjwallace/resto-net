require 'spec_helper'

describe Owner do
  it { should have_many(:ownerships) }
  it { should have_many(:establishments).through(:ownerships) }
  it { should validate_presence_of(:name) }
end
