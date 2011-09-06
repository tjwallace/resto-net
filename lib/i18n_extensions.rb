module I18nExtensions
  def translate_attribute(object, attribute_name)
    attribute_value = object.send(attribute_name)
    t(attribute_name, :scope => [:values, object.class.model_name.singular])[attribute_value.to_sym] || attribute_value unless attribute_value.nil?
  end
end

module I18n
  class << self
    include I18nExtensions
  end
end
