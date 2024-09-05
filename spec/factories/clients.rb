# frozen_string_literal: true

# spec/factories/clients.rb
FactoryBot.define do
  # Factory for creating Client instances
  #
  # @!attribute name
  #   @return [String] A randomly generated company name
  factory :client do
    name { Faker::Company.name }
  end
end
