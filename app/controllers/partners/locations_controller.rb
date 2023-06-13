module Partners
  class LocationsController < ApplicationController
    def index
      render json: paginated_response(scoped_locations), status: :ok
    end

    private

    def scoped_locations
      Location.includes(:machine).where(machines: { partner_id: params[:partner_id] })
    end
  end
end