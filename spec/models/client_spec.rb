# frozen_string_literal: true

# spec/models/client_spec.rb
require 'rails_helper'

RSpec.describe Client, type: :model do
  it { should have_many(:buildings) }
  it { should have_many(:custom_fields) }

  it 'is valid with a name' do
    client = build(:client)
    expect(client).to be_valid
  end

  it 'is invalid without a name' do
    client = build(:client, name: nil)
    expect(client).not_to be_valid
  end

  describe 'dependent: :destroy' do
    let!(:client) { create(:client) }
    let!(:building) { create(:building, client: client) }
    let!(:custom_field) { create(:custom_field, client: client) }

    it 'destroys associated buildings when client is destroyed' do
      expect { client.destroy }.to change { Building.count }.by(-1)
    end

    it 'destroys associated custom_fields when client is destroyed' do
      expect { client.destroy }.to change { CustomField.count }.by(-1)
    end
  end
end
