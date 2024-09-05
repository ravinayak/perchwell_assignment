# frozen_string_literal: true

module BuildingOperations
  extend ActiveSupport::Concern

  private

  def set_building
    @building = Building.find(params[:id])
  end

  def building_params
    params.require(:building)
          .permit(:address, :state, :zip, :client_id,
                  building_custom_fields_attributes: custom_field_attributes)
  end

  def custom_field_attributes
    %i[id custom_field_id value _destroy]
  end

  def building_object(building)
    {
      id: building.id,
      client_name: building.client.name,
      address: building.address,
      state: building.state,
      zip: building.zip,
      custom_fields: custom_fields(building),
      created_at: building.created_at,
      updated_at: building.updated_at
    }
  end

  def custom_fields(building)
    building.building_custom_fields.map do |bcf|
      { id: bcf.id, name: bcf.custom_field.name, value: bcf.value }
    end
  end

  def render_error(errors)
    render json: { status: 'error', errors: errors }, status: :unprocessable_entity
  end

  def record_not_found
    render json: { status: 'error', message: 'Building not found' }, status: :not_found
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
