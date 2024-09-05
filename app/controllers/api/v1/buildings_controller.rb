# frozen_string_literal: true

module Api
  module V1
    class BuildingsController < ApplicationController
      include BuildingOperations

      PER_PAGE = 10
      skip_before_action :verify_authenticity_token, only: %i[index show create update destroy]
      before_action :set_building, only: %i[show update destroy]
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      # @return [void]
      # Lists all buildings with pagination
      def index
        @buildings = Building.includes(:client, :building_custom_fields)
                             .order(created_at: :desc)
                             .page(params[:page]).per(params[:per_page] || PER_PAGE)

        render json: {
          status: 'success',
          buildings: @buildings.map { |b| building_object(b) },
          meta: pagination_meta(@buildings)
        }
      end

      # @return [void]
      # Shows details of a specific building
      def show
        render json: { status: 'success', building: building_object(@building) }
      end

      # @return [void]
      # Creates a new building
      def create
        @building = Building.new(building_params)
        if @building.save
          render json: { status: 'success', building: building_object(@building) }, status: :created
        else
          render_error(@building.errors.full_messages)
        end
      end

      # @return [void]
      # Updates an existing building
      def update
        if @building.update(building_params)
          render json: { status: 'success', building: building_object(@building) }
        else
          render_error(@building.errors.full_messages)
        end
      end

      # @return [void]
      # Deletes an existing building
      def destroy
        @building.destroy
        head :no_content
      end
    end
  end
end
