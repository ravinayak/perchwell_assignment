# frozen_string_literal: true

# spec/models/custom_field_spec.rb
require 'rails_helper'

RSpec.describe CustomField, type: :model do
  it { should belong_to(:client) }
  it { should have_many(:building_custom_fields).dependent(:destroy) }

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
end
