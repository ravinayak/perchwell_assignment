# frozen_string_literal: true

# app/models/building.rb
class Building < ApplicationRecord
  belongs_to :client
  has_many :building_custom_fields, dependent: :destroy
  has_many :custom_fields, through: :building_custom_fields
  accepts_nested_attributes_for :building_custom_fields, allow_destroy: true

  validates :address, :state, :zip, presence: true
end
