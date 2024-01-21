# frozen_string_literal: true

module Partners
  class PrizesController < ApplicationController
    def index
      @pagy, @collection = pagy(scoped_prizes)
      render json: paginated_response, status: :ok
    end

    private

    def scoped_prizes
      Prize.where(partner_id: params[:partner_id])
    end
  end
end
