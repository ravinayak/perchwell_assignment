# frozen_string_literal: true

# db/migrate/xxxxx_create_custom_fields.rb
class CreateCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_fields do |t|
      t.string :field_type, null: false
      t.string :name, null: false
      t.string :options
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
