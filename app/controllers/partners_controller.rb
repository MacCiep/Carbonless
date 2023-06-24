class PartnersController < ApplicationController
  def index
    if params[:latitude] && params[:longitude]
      response = PartnerBlueprint.render_as_hash(
        scoped_partners,
        view: :with_locations,
        latitude: latitude,
        longitude: longitude,
        range: range
      )
    else
      @pagy, @records = pagy(scoped_partners)
      @records = PartnerBlueprint.render_as_hash(@records)
      response = paginated_response
    end

    render json: response, status: :ok
  end

  private

  def scoped_partners
    if latitude && longitude
      machines_ids = Location.with_nearby_machines(latitude, longitude, range).pluck(:machine_id).uniq
      Partner.joins(:machines).where(machines: { id: machines_ids }).distinct
    else
      Partner.all
    end
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