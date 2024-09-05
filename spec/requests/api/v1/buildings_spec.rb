# frozen_string_literal: true

# spec/requests/api/v1/buildings_spec.rb
require 'rails_helper'

RSpec.describe 'Buildings API', type: :request do
  let!(:client) { create(:client) }
  let!(:buildings) { create_list(:building, 5, client: client) }
  let(:building_id) { buildings.first.id }

  describe 'GET /api/v1/buildings' do
    before { get '/api/v1/buildings' }

    it 'returns buildings' do
      expect(json).not_to be_empty
      expect(json['buildings'].size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /api/v1/buildings' do
    let(:valid_attributes) do
      { building: { address: '789 New St', state: 'CA', zip: '94016', client_id: client.id } }
    end

    context 'when the request is valid' do
      before { post '/api/v1/buildings', params: valid_attributes }

      it 'creates a building' do
        expect(json['status']).to eq('success')
        expect(json['building']['address']).to eq('789 New St')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/buildings', params: { building: { address: 'Foobar' } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['status']).to eq('error')
      end
    end
  end

  describe 'PATCH /api/v1/buildings/:id' do
    let(:valid_attributes) { { building: { address: '456 Updated St' } } }

    context 'when the building exists' do
      before { patch "/api/v1/buildings/#{building_id}", params: valid_attributes }

      it 'updates the building' do
        expect(json['status']).to eq('success')
        expect(json['building']['address']).to eq('456 Updated St')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the building does not exist' do
      before { patch '/api/v1/buildings/999', params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['status']).to eq('error')
      end
    end
  end
end
