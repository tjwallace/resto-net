module I18nExtensions
  def translate_attribute(object, attribute_name)
    attribute_value = object.send(attribute_name)
    t(attribute_value.to_s, :scope => [ :attributes, object.class.name, attribute_name ], :default => attribute_value.to_s) unless attribute_value.nil?
  end
end

module I18n
  class << self
    include I18nExtensions
  end
end
