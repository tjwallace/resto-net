require 'spec_helper'

describe Owner do
  it { should have_many(:infractions) }
  it { should have_many(:establishments).through(:infractions) }
  it { should validate_presence_of(:name) }
end
