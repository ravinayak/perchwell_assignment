# README

## Setup Instructions

1. Clone the repository: To clone the respository, use the following command:
   ```
   git clone git@github.com:ravinayak/perchwell_assignment.git
   ```
2. Install dependencies: Dependencies can be installed using the following command:
   ```
   cd perchwell_assignment
   bundle install
   ```
3. Set up the database: To setup database for development and test, use the following commands:
   To setup database for development environment
   ```
   rails db:create
   rails db:migrate
   ```
4. Run the server: We can run the rails server at port 3000 by using 'rails s -p 3000'. When you
   start the application it will try to create database with seed data. The database must be created
   first and migrations should be run (or schema file should be loaded).
   ```
   rails db:create (if database has not been created)
   rails db:schema:load OR rails db:migrate (if database has not been created)
   rails s -p <port_number>
   ```
5. Running Tests: Tests can be run for the application when we are in the project directory. All tests
   are in spec directory. First we have to create test database, load the schema, and then we can run
   tests
   ```
   cd perchwell_assignment
   RAILS_ENV=test rails db:create
   RAILS_ENV=test rails db:migrate
   rspec
   ```

## API Endpoints:

There are 4 API Endpoints:

- **GET /api/v1/buildings**: This is an index action, and it returns all the buildings in database in specific format, an
  array of building objects is returned where each building object has a structure defined as below:
  defined as below:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "building": {
      "type": "object",
      "properties": {
        "id": { "type": "integer" },
        "address": { "type": "string" },
        "state": { "type": "string" },
        "zip": { "type": "string" },
        "client_id": { "type": "integer" },
        "building_custom_fields_attributes": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "custom_field_id": { "type": "integer" },
              "value": {
                "oneOf": [
                  {
                    "type": "string",
                    "enum": ["enum_value1", "enum_value2"]
                  },
                  { "type": "string" },
                  { "type": "number" }
                ]
              }
            },
            "required": ["custom_field_id", "value"]
          }
        },
        "created_at": { "type": "string", "format": "date-time" },
        "updated_at": { "type": "string", "format": "date-time" }
      },
      "required": [
        "id",
        "address",
        "state",
        "zip",
        "client_id",
        "building_custom_fields_attributes",
        "created_at",
        "updated_at"
      ]
    }
  },
  "required": ["building"]
}
```

JSON format of response is as defined below:

```json
{
  "status": "string",
  "buildings": [
    {
      "building": {
        "id": "integer",
        "address": "string",
        "state": "string",
        "zip": "string",
        "client_id": "integer",
        "building_custom_fields_attributes": [
          {
            "custom_field_id": "integer",
            "value": "string | number"
          }
        ],
        "created_at": "string",
        "updated_at": "string"
      }
    }
  ]
}
```

- **GET /api/v1/buildings/id**: This fetches information about a specific building. It returns an error 'Not Found', if
  building is not found.

JSON format of response is as defined below:

```json
{
  "status": "string",
  "building": {
    "id": "integer",
    "address": "string",
    "state": "string",
    "zip": "string",
    "client_id": "integer",
    "building_custom_fields_attributes": [
      {
        "custom_field_id": "integer",
        "value": "string | number"
      }
    ],
    "created_at": "string",
    "updated_at": "string"
  }
}
```

- **POST /api/v1/buildings**: This endpoint allows us to create a building. It returns the building which was created or an error
  response if building could not be created.

JSON format of payload is as defined as below:

```json
{
  "building": {
  "address": "string",
  "state": "string",
  "zip": "string",
  "client_id": "integer",
  "building_custom_fields_attributes": [
    {
      "custom_field_id": "integer",
      "value": "string | number"
    }
  ]
}
```

- **PATCH /api/v1/buildings/id**: This endpoint allows us to edit a building information. Its format is similar to POST
  JSON Format

## Curl Requests for Accessing APIs:

- **Create Building**:
  curl -X POST -d '{"building": {"address": "123 Main St", "state": "NY", "zip": "10001", "client_id": 1, "building_custom_fields_attributes": [{"custom_field_id": 1, "value": "2.5"}]}}' -H "Content-Type: application/json" http://localhost:3000/api/v1/buildings

- **Edit Building**:
  curl -X PATCH -d '{"building": {"address": "124 Main St", "state": "NY", "zip": "10001"}}' -H "Content-Type: application/json" http://localhost:3000/api/v1/buildings/1

- **Read Buildings**:
  curl http://localhost:3000/api/v1/buildings

## Sample Code to test APIs in Ruby

This application can be tested for functionality using the following code snippet
in Ruby. In order to use this code, we must first start the application at a specific
port - (say 3000). This is essential because

```
1. Unless application is running, API endpoints will not be available.
2. seeds.rb is used to seed the database and create records in database only when we
   start the application. Once application is running, the following code can be used
```

```ruby
require 'net/http'
require 'json'

def test_building_api
  base_url = 'http://localhost:3000/api/v1'
  client_id = Client.first.id
  custom_field_id = CustomField.where(field_type: 'number').first.id
  # Create Building
  create_data = {
    building: {
      address: "123 Main St",
      state: "NY",
      zip: "10001",
      client_id: client_id,
      building_custom_fields_attributes: [
        { custom_field_id: custom_field_id, value: 50 }
      ]
    }
  }
  create_response = api_request('POST', "#{base_url}/buildings", create_data)
  puts "Create Building Response: #{create_response}"

  # Edit Building (assuming the created building has id 1)
  edit_data = {
    building: {
      address: "124 Main St",
      state: "NY",
      zip: "10001"
    }
  }
  building_id = Building.first.id
  edit_response = api_request('PATCH', "#{base_url}/buildings/#{building_id}", edit_data)
  puts "Edit Building Response: #{edit_response}"

  # Read Buildings
  read_response = api_request('GET', "#{base_url}/buildings")
  puts "Read Buildings Response: #{read_response}"
end

def api_request(method, url, data = nil)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)

  case method
  when 'GET'
    request = Net::HTTP::Get.new(uri)
  when 'POST'
    request = Net::HTTP::Post.new(uri)
  when 'PATCH'
    request = Net::HTTP::Patch.new(uri)
  else
    raise "Unsupported HTTP method: #{method}"
  end

  request['Content-Type'] = 'application/json'
  request.body = data.to_json if data

  response = http.request(request)
  JSON.parse(response.body)
rescue => e
  { error: e.message }
end

# Run the test
test_building_api
```

To run the above code snippet, either copy code into a file and load it in rails console
or simply copy/paste the entire code snippet in rails console:

```
cd perchwell_assignment
rails console
```
