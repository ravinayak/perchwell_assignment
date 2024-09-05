# frozen_string_literal: true

# spec/models/building_spec.rb
require 'rails_helper'

RSpec.describe Building, type: :model do
  it { should belong_to(:client) }
  it { should have_many(:building_custom_fields) }
  it { should have_many(:custom_fields).through(:building_custom_fields) }

  # Test validations
  it 'is valid with an address, state, zip, and client' do
    building = build(:building)
    expect(building).to be_valid
  end

  it 'is invalid without an address' do
    building = build(:building, address: nil)
    expect(building).not_to be_valid
  end

  it 'is invalid without a state' do
    building = build(:building, state: nil)
    expect(building).not_to be_valid
  end

  it 'is invalid without a zip' do
    building = build(:building, zip: nil)
    expect(building).not_to be_valid
  end

  describe 'dependent: :destroy' do
    let!(:building) { create(:building) }
    let!(:building_custom_field) { create(:building_custom_field, building: building) }

    it 'destroys associated building_custom_fields when building is destroyed' do
      expect { building.destroy }.to change { BuildingCustomField.count }.by(-1)
    end
  end

  it { should belong_to(:client) }
  it { should have_many(:building_custom_fields) }

  # Test validations
  it 'is valid with a name and field type' do
    custom_field = build(:custom_field)
    expect(custom_field).to be_valid
  end

  it 'is invalid without a name' do
    custom_field = build(:custom_field, name: nil)
    expect(custom_field).not_to be_valid
  end

  it 'is invalid without a field type' do
    custom_field = build(:custom_field, field_type: nil)
    expect(custom_field).not_to be_valid
  end

  it 'is invalid with an unsupported field type' do
    custom_field = build(:custom_field, field_type: 'unsupported')
    expect(custom_field).not_to be_valid
  end

  it { should belong_to(:client) }
  it { should have_many(:building_custom_fields).dependent(:destroy) }
  it { should have_many(:custom_fields).through(:building_custom_fields) }

  describe 'dependent: :destroy' do
    let!(:building) { create(:building) }

    # Create a custom field of type 'number' and associate it with the building
    let!(:custom_field) { create(:custom_field, field_type: 'number', client: building.client) }
    let!(:building_custom_field) { create(:building_custom_field, building: building, custom_field: custom_field) }

    it 'destroys associated building_custom_fields when building is destroyed' do
      expect { building.destroy }.to change { BuildingCustomField.count }.by(-1)
    end
  end
end
