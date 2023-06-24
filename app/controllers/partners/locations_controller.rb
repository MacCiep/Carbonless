module Partners
  class LocationsController < ApplicationController
    def index
      if params[:latitude] && params[:longitude]
        response = LocationBlueprint.render_as_hash(scoped_locations)
      else
        @pagy, @records = pagy(scoped_locations)
        @records = LocationBlueprint.render_as_hash(@records)
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
      if params[:range] && params[:range]&.to_f > 50
        raise ActionController::BadRequest, 'Range cannot be greater than 50'
      end

      params[:range]&.to_f || 10
    end
  end
end