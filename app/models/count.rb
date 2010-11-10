class Count
  attr_accessor :label, :count, :kind

  def initialize(attributes)
    attributes.each do |attribute, value|
      instance_variable_set("@#{attribute}", value) if respond_to? "#{attribute}="
    end
  end
end
