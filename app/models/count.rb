class Count
  include ActionView::Helpers::NumberHelper

  attr_accessor :label, :count, :kind, :type

  def initialize(attributes)
    attributes.each do |attribute, value|
      instance_variable_set("@#{attribute}", value) if respond_to? "#{attribute}="
    end
  end

  def pretty_count
    case type
    when :currency
      number_to_currency count, :precision => 0
    when :integer
      number_with_delimiter count.to_i
    else
      count
    end
  end
end
