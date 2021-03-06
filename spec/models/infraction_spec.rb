require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Infraction do
  it { should belong_to(:establishment) }
  it { should belong_to(:owner) }

  %w(establishment owner amount infraction_date judgment_date).each do |attr|
    it { should validate_presence_of(attr) }
  end
  it { should validate_numericality_of(:amount) }
  [-1, 1.1].each do |value|
    it { should_not allow_value(value).for(:amount) }
  end
  [1, 100, 1000].each do |value|
    it { should allow_value(value).for(:amount) }
  end
end
