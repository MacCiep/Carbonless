# frozen_string_literal: true

module Partners
  class LocationsController < ApplicationController
    def index
      if params[:latitude] && params[:longitude]
        response = LocationBlueprint.render_as_hash(scoped_locations)
      else
        @pagy, @collection = pagy(scoped_locations)
        @collection = LocationBlueprint.render_as_hash(@collection)
        response = paginated_response
      end

      render json: response, status: :ok
    end

    private

    def scoped_locations
      locations = Location.includes(:machine).where(machines: { partner_id: params[:partner_id] })
      latitude && longitude ? locations.with_nearby_machines(latitude, longitude, range) : locations
    end

    def latitude
      params[:latitude]&.to_f
    end

    def longitude
      params[:longitude]&.to_f
    end

    def range
      range_value = params[:range]&.to_f
      if range_value.present? && (range_value > 50)
        raise ActionController::BadRequest, 'Range cannot be greater than 50'
      end

      range_value || 10
    end
  end
end
