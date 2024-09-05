# frozen_string_literal: true

# spec/models/building_custom_field_spec.rb
require 'rails_helper'

RSpec.describe BuildingCustomField, type: :model do
  let(:client) { create(:client) }
  let(:building) { create(:building, client: client) }
  let(:custom_field) { create(:custom_field, field_type: 'number', client: client) }

  it { should belong_to(:building) }
  it { should belong_to(:custom_field).required(true) }

  context 'validations' do
    let(:building_custom_field) { build(:building_custom_field, building: building, custom_field: custom_field) }

    it 'validates number field type correctly' do
      building_custom_field.value = '12.5'
      expect(building_custom_field).to be_valid

      building_custom_field.value = 'not a number'
      expect(building_custom_field).not_to be_valid
    end

    it 'validates freeform field type correctly' do
      custom_field.update(field_type: 'freeform')
      building_custom_field.value = 'any string'
      expect(building_custom_field).to be_valid
    end

    it 'validates enum field type correctly' do
      custom_field.update(field_type: 'enum', options: 'Option 1, Option 2, Option 3')
      building_custom_field.value = 'Option 1'
      expect(building_custom_field).to be_valid

      building_custom_field.value = 'Invalid Option'
      expect(building_custom_field).not_to be_valid
      expect(building_custom_field.errors[:value]).to include('is not a valid option')

      # Test the edge case where value is nil
      building_custom_field.value = nil
      expect(building_custom_field).not_to be_valid
      expect(building_custom_field.errors[:value]).to include('cannot be blank for enum field')
    end
  end
end
