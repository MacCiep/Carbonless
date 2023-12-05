module Api
  class ExchangeItemsController < ApiController
    before_action :set_exchange_item, only: [:show, :update, :destroy, :activate, :cancel, :exchange, :inactivate]

    def index
      @pagy, @records = pagy(ExchangeItem.all)
      @records = ExchangeItemBlueprint.render_as_hash(@records)
      render json: paginated_response
    end

    def show
      render json: ExchangeItemBlueprint.render_as_hash(@exchange_item)
    end

    def create
      @exchange_item = current_user.exchange_items.new(exchange_item_params)

      if @exchange_item.save
        render json: ExchangeItemBlueprint.render_as_hash(@exchange_item), status: :created
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    def update
      authorize @exchange_item
      if @exchange_item.update(exchange_item_params)
        render json: @exchange_item
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    def activate
      authorize @exchange_item
      if @exchange_item.activate!
        head :ok
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    def cancel
      authorize @exchange_item
      if @exchange_item.update(status: :cancelled)
        head :ok
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    def exchange
      authorize @exchange_item
      if @exchange_item.update(status: :exchanged)
        head :ok
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    def inactivate
      authorize @exchange_item
      if @exchange_item.update(status: :inactive)
        head :ok
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @exchange_item
      if @exchange_item.destroy
        head :no_content
      else
        render json: @exchange_item.errors, status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_exchange_item
      @exchange_item = ExchangeItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def exchange_item_params
      params.require(:exchange_item).permit(:name, :description, :user_id)
    end
  end
end