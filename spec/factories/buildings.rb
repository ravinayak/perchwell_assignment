# frozen_string_literal: true

# spec/factories/buildings.rb
FactoryBot.define do
  # Factory for creating Building instances
  #
  # @!attribute address
  #   @return [String] A randomly generated street address
  # @!attribute state
  #   @return [String] A randomly generated state abbreviation
  # @!attribute zip
  #   @return [String] A randomly generated zip code
  # @!attribute client
  #   @return [Client] An associated client instance
  factory :building do
    address { Faker::Address.street_address }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    client
  end
end
