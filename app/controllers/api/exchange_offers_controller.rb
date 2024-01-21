# frozen_string_literal: true

module Api
  class ExchangeOffersController < ApiController
    before_action :set_exchange_offer, only: %i[show destroy accept reject complete]
    before_action :set_collection, only: [:index]

    def index
      apply_filters
      @pagy, @collection = pagy(@collection)
      @collection = ExchangeOfferBlueprint.render_as_hash(@collection)
      render json: paginated_response
    end

    def show
      render json: ExchangeOfferBlueprint.render_as_hash(@exchange_offer)
    end

    def create
      @exchange_offer = current_user.exchange_offers.new(exchange_offer_params)

      if exchange_offer_valid?(@exchange_offer.description)
        @exchange_offer.save
        render json: ExchangeOfferBlueprint.render_as_hash(@exchange_offer), status: :created
      else
        render json: error, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @exchange_offer
      if @exchange_offer.destroy
        head :no_content
      else
        @error = @exchange_offer.errors.full_messages
        render json: error, status: :unprocessable_entity
      end
    end

    def accept
      authorize @exchange_offer
      @exchange_offer.response_description = response_params[:response_description]
      if exchange_offer_valid?(@exchange_offer.response_description) && @exchange_offer.accept!
        @exchange_offer.save
        head :ok
      else
        render json: error, status: :unprocessable_entity
      end
    end

    def reject
      authorize @exchange_offer
      @exchange_offer.response_description = response_params[:response_description]
      if exchange_offer_valid?(@exchange_offer.response_description) && @exchange_offer.reject
        @exchange_offer.save
        head :ok
      else
        render json: error, status: :unprocessable_entity
      end
    end

    def complete
      authorize @exchange_offer

      if @exchange_offer.complete!
        head :ok
      else
        @error = @exchange_offer.errors.full_messages
        render json: error, status: :unprocessable_entity
      end
    end

    private

    # TODO: Refactor it!, think about better solution to connect it with similar method in exchange_items_controller.rb
    def exchange_offer_valid?(moderation_field)
      if @exchange_offer.invalid?
        @error = @exchange_offer.errors.full_messages
      elsif !Moderation::ModerateMessage.new(current_user, moderation_field).call
        @error = 'Please do not use bad words in description, if this happens again your account will be blocked'
      else
        return true
      end

      false
    end

    def set_exchange_offer
      @exchange_offer = ExchangeOffer.find(params[:id])
    end

    def exchange_offer_params
      params.require(:exchange_offer).permit(:exchange_item_id, :description)
    end

    def response_params
      params.require(:exchange_offer).permit(:response_description)
    end

    def attributes_filter_params
      params.permit(:status)
    end

    def set_collection
      case params[:scope].to_s.downcase
      when 'my'
        @collection = current_user.exchange_offers
      when 'others'
        @collection = ExchangeOffer.includes(:exchange_item).where(exchange_item: { user_id: current_user.id })
      else
        render json: { error: 'Invalid scope parameter' }, status: :unprocessable_entity
      end
    end
  end
end
