# frozen_string_literal: true

# app/models/custom_field.rb
class CustomField < ApplicationRecord
  belongs_to :client
  has_many :building_custom_fields, dependent: :destroy

  validates :name, :field_type, presence: true
  validates :field_type, inclusion: { in: %w[number freeform enum] }

  validate :validate_options_for_enum

  private

  # Validates that options are provided for enum field types
  #
  # @return [void]
  def validate_options_for_enum
    return unless valid_options?(field_type, options)

    errors.add(:options, 'must be provided for enum field types')
  end

  # Checks if the field type is enum and options are blank
  #
  # @param field_type [String] the type of the custom field
  # @param options [Array, nil] the options for the custom field
  # @return [Boolean] true if field type is enum and options are blank, false otherwise
  def valid_options?(field_type, options)
    field_type == 'enum' && options.blank?
  end
end
