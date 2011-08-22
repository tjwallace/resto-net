class Count
  include ActionView::Helpers::NumberHelper

  attr_accessor :label, :span, :count, :kind, :label_style, :count_style

  def initialize(attributes)
    attributes.each do |attribute, value|
      instance_variable_set("@#{attribute}", value) if respond_to? "#{attribute}="
    end
  end

  def pretty_label
    if label
      pretty(label, label_style)
    else
      "#{pretty(span.first, label_style)}–#{pretty(span.last, label_style)}"
    end
  end

  def pretty_count
    pretty(count, count_style)
  end

private

  def pretty(value, style)
    case style
    when :currency
      number_to_currency value, :precision => 0
    when :integer
      number_with_delimiter value.to_i
    else
      value
    end
  end
end
