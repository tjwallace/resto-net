require 'spec_helper'

describe Ownership do
  it { should belong_to(:owner) }
  it { should belong_to(:establishment) }

  %w(owner establishment).each do |attr|
    it { should validate_presence_of(attr) }
  end
end
