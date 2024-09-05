# frozen_string_literal: true

# spec/factories/building_custom_fields.rb
FactoryBot.define do
  # Factory for creating BuildingCustomField instances
  #
  # @!attribute building
  #   @return [Building] Associated building for the custom field
  # @!attribute custom_field
  #   @return [CustomField] Associated custom field
  # @!attribute value
  #   @return [String, Numeric] The value of the custom field, generated based on the field type
  factory :building_custom_field do
    building
    custom_field

    # Dynamically generate the value based on the custom field's type
    #
    # @return [String, Numeric] Generated value for the custom field
    value do
      case custom_field.field_type
      when 'number'
        Faker::Number.decimal(l_digits: 2)
      when 'freeform'
        Faker::Lorem.sentence
      when 'enum'
        # Assuming enum options are provided as a comma-separated string in `custom_field.options`
        custom_field.options&.split(',')&.sample&.strip || Faker::Lorem.word
      else
        Faker::Lorem.word
      end
    end
  end
end
