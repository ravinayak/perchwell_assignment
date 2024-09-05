# frozen_string_literal: true

# app/models/client.rb
class Client < ApplicationRecord
  has_many :buildings, dependent: :destroy
  has_many :custom_fields, dependent: :destroy

  # Add validation for name presence
  validates :name, presence: true
end
