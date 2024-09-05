# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# db/seeds.rb

# Create 5 clients, custom_fields for each client, and 3 buildings for each client
#
# Seed clients if they don't exist
client_names = ['Test Corp', 'Test Cabal', 'WhiteFactory', 'DesignSystems', 'ShriGamGanpati']

clients = client_names.map do |name|
  Client.find_or_create_by(name: name)
end

clients.each_with_index do |client, index|
  # Create custom fields for each client if they don't exist
  custom_field_data = [
    { name: 'Number of rooms', field_type: 'number' },
    { name: 'Color of Hall', field_type: 'freeform' },
    { name: 'Type of Bathroom', field_type: 'enum', options: ['Full', 'Half', 'Two-quarter', 'Slave'] },
    { name: 'Year of Construction', field_type: 'number' }
  ]

  custom_fields = custom_field_data.map do |field|
    # Use find_or_create_by with all relevant attributes to ensure uniqueness
    CustomField.find_or_create_by(
      name: field[:name],
      field_type: field[:field_type],
      client: client
    ) do |custom_field|
      custom_field.options = field[:options] if field[:options]
    end
  end

  address_hsh = {
    0 => 
      {
        0 => '100 Main St',
        1 => '101 Main St',
        2 => '102 Main St'
      },
    1 => 
      {
        0 => '103 Main St',
        1 => '104 Main St',
        2 => '105 Main St'
      },
    2 => 
      {
        0 => '106 Main St',
        1 => '107 Main St',
        2 => '108 Main St'
      },
    3 => 
      {
        0 => '109 Main St',
        1 => '110 Main St',
        2 => '111 Main St'
      },
    4 => 
      {
        0 => '112 Elm St',
        1 => '113 Elm St',
        2 => '114 Elm St'
      }
  }

  state_hsh = {
    0 => 'NY',
    1 => 'NJ',
    2 => 'CA',
    3 => 'MI',
    4 => 'IL'
  }
  zip_hsh = {
    0 => 1001,
    1 => 1002,
    2 => 1003,
    3 => 1004,
    4 => 1005
  }

  custom_fields_hsh = {
    0 => {
      'Number of rooms' =>  5,
      'Color of Hall' =>  'Blue',
      'Type of Bathroom' =>  'Full',
      'Year of Construction' =>  2000
    },
    1 => {
      'Number of rooms' => 8,
      'Color of Hall' => 'White',
      'Type of Bathroom' => 'Half',
      'Year of Construction' => 2005
    },
    2 => {
      'Number of rooms' => 6,
      'Color of Hall' => 'Green',
      'Type of Bathroom' => 'Two-quarter',
      'Year of Construction' => 2010
    },
    3 => {
      'Number of rooms' => 10,
      'Color of Hall' => 'Purple',
      'Type of Bathroom' => 'Full',
      'Year of Construction' => 2015
    },
    4 => {
      'Number of rooms' => 7,
      'Color of Hall' => 'Black',
      'Type of Bathroom' => 'Slave',
      'Year of Construction' => 2020
    }
}

  # Create buildings for each client with custom field values if they don't exist
  3.times do |i|
    address = address_hsh[index][i]
    state = state_hsh[index]
    zip = zip_hsh[index].to_s

    building = Building.find_or_create_by(
      address: address,
      state: state,
      zip: zip,
      client: client
    )

    # Add custom field values for the building if they don't exist
    custom_fields.each do |field|
      value = custom_fields_hsh[index][field]

      BuildingCustomField.find_or_create_by(
        custom_field: field,
        building: building
      ) do |cfv|
        cfv.value = value.to_s
      end
    end
  end
end

puts 'Seeding completed!'
