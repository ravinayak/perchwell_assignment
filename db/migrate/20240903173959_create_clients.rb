# frozen_string_literal: true

# db/migrate/xxxxx_create_clients.rb
class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
