# frozen_string_literal: true

# app/models/building_custom_field.rb
class BuildingCustomField < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field, required: true

  validate :validate_field_type

  private

  # Validates the field type based on the associated custom field
  #
  # @return [void]
  def validate_field_type
    # Ensure custom_field is present to avoid nil errors
    return unless custom_field

    case custom_field.field_type
    when 'number'
      errors.add(:value, 'must be a number') unless valid_number?(value)
    when 'freeform'
      # No specific validation needed for freeform strings
    when 'enum'
      if value.nil?
        errors.add(:value, 'cannot be blank for enum field')
      else
        errors.add(:value, 'is not a valid option') unless valid_options?(value)
      end
    end
  end

  # Checks if the given value is a valid number
  #
  # @param value [String] The value to be validated
  # @return [Boolean] True if the value is a valid number, false otherwise
  def valid_number?(value)
    value.to_f.to_s == value.to_s || value.to_i.to_s == value.to_s
  end

  # Validates that the value is one of the enum options
  #
  # @param value [String] The value to be validated
  # @return [Array<String>] An array of valid options
  def valid_options?(value)
    custom_field.options.split(',').map(&:strip).include?(value)
  end
end
