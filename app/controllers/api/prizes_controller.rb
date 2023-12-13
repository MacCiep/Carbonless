module Api
  class PrizesController < ApiController
    before_action :set_prize, only: %i[update show destroy]

    def index
      @pagy, @records = pagy(Prize.all.order("id ASC").except(:uuid))
      render json: paginated_response, status: :ok
    end

    def create
      @prize = Prize.create(prize_params)
      if @prize.save
        render json: @prize, status: :created
      else
        @error = @prize.errors.full_messages
        render json: error, status: :unprocessable_entity
      end
    end

    def show
      render json: @prize, status: :ok
    end

    def update
      if @prize.update(prize_params)
        render status: :ok
      else
        @error = @prize.errors.full_messages
        render json: error, status: :unprocessable_entity
      end
    end

    def destroy
      if @prize.destroy
        render status: :ok
      else
        @error = @prize.errors.full_messages
        render json: error, status: :unprocessable_entity
      end
    end

    def prize_params
      params.require(:prize).permit(:title, :price, :duration)
    end

    def set_prize
      @prize = Prize.find(params[:id])
    end
  end
end