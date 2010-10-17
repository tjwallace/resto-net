require 'spec_helper'

describe Owner do
  it { should have_many(:establishments).dependent(:destroy) }
  it { should validate_presence_of(:name) }
end
