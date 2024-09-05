# frozen_string_literal: true

# spec/factories/custom_fields.rb
FactoryBot.define do
  # Factory for creating CustomField instances
  #
  # @!attribute client
  #   @return [Client] An associated client instance
  # @!attribute name
  #   @return [String] A randomly generated word for the custom field name
  # @!attribute field_type
  #   @return [String] A randomly selected field type from 'number', 'freeform', or 'enum'
  # @!attribute options
  #   @return [String, nil] A comma-separated string of options for 'enum' type, nil for other types
  factory :custom_field do
    client
    name { Faker::Lorem.word }
    field_type { %w[number freeform enum].sample }

    # Ensure options are set only for enum type fields
    #
    # @return [String, nil] Options string for 'enum' type, nil for other types
    options { field_type == 'enum' ? 'Option 1, Option 2, Option 3' : nil }
  end
end
