# frozen_string_literal: true

# db/migrate/xxxxx_create_building_custom_fields.rb
class CreateBuildingCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :building_custom_fields do |t|
      t.references :building, null: false, foreign_key: true
      t.references :custom_field, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
    add_index :building_custom_fields, %i[building_id custom_field_id], unique: true
  end
end
