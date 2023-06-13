class PartnersController < ApplicationController
  def index
    render json: paginated_response(scoped_partners), status: :ok
  end

  private

  def scoped_partners
    Partner.all
  end
end