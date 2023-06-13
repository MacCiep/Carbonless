module Partners
  class PrizesController < ApplicationController
    def index
      render json: paginated_response(scoped_prizes), status: :ok
    end

    private

    def scoped_prizes
      Prize.where(partner_id: params[:partner_id])
    end
  end
end