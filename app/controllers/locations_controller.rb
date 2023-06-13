class LocationsController < ApplicationController
  def index
    if params[:latitude] && params[:longitude]
      render json: paginated_response(scoped_locations), status: :ok
    else
      return render json: { errors: { latitude: ["can't be blank"], longitude: ["can't be blank"] } }, status: :bad_request
    end
  end

  private

  def scoped_locations
    Location.with_nearby_machines(params[:latitude].to_f, params[:longitude].to_f)
  end
end