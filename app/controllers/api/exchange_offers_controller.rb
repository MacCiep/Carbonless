module Api
  class ExchangeOffersController < ApiController
    before_action :set_exchange_offer, only: [:show, :destroy]
    before_action :set_scope, only: [:index]

    def index
      @pagy, @records = pagy(@scope)
      @records = ExchangeOfferBlueprint.render_as_hash(@records)
      render json: paginated_response
    end

    def show
      render json: ExchangeOfferBlueprint.render_as_hash(@exchange_offer)
    end

    def create
      @exchange_offer = current_user.exchange_offers.new(exchange_offer_params)

      if @exchange_offer.valid?
        authorize @exchange_offer
        @exchange_offer.save
        render json: ExchangeOfferBlueprint.render_as_hash(@exchange_offer), status: :created
      else
        render json: @exchange_offer.errors, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @exchange_offer
      if @exchange_offer.destroy
        head :no_content
      else
        render json: @exchange_offer.errors, status: :unprocessable_entity
      end
    end

    private

    def set_exchange_offer
      @exchange_offer = ExchangeOffer.find(params[:id])
    end

    def exchange_offer_params
      params.require(:exchange_offer).permit(:exchange_item_id, :description)
    end

    def set_scope
      case params[:scope].to_s.downcase
      when 'my'
        @scope = current_user.exchange_offers
      when 'others'
        @scope = ExchangeOffer.includes(:exchange_item).where(exchange_item: { user_id: current_user.id })
      else
        render json: { error: 'Invalid scope parameter' }, status: :unprocessable_entity
      end
    end
  end
end