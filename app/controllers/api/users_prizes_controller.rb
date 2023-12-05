module Api
  class UsersPrizesController < ApiController
    before_action :set_user_prize, only: %i[show update]
    before_action :set_prize, only: %i[create]

    def index
      @pagy, @records = pagy(current_user.users_prizes)
      render json: paginated_response, status: :ok
    end

    def create
      new_prize = current_user.users_prizes.new(user_prize_params_create)
      return head :unprocessable_entity unless user_have_enough_points?

      current_user.points -= @prize.price
      ActiveRecord::Base.transaction do
        if new_prize.save && current_user.save
          head :created
        else
          head :unprocessable_entity
        end
      end
    end

    def update
      authorize @prize

      if @prize.update(active: false)
        head :ok
      else
        render json: @prize.errors.full_messages, status: :unprocessable_entity
      end
    end

    def show
      authorize @prize

      render json: UsersPrizes::ValidateUserPrize.new(@prize).call, status: :ok
    end

    private

    def set_user_prize
      @prize = UsersPrize.find(params[:id])
    end

    def set_prize
      @prize = Prize.find(params[:user_prize][:prize_id])
    end

    def user_prize_params_create
      params.require(:user_prize).permit(:prize_id)
    end

    def user_prize_params_update
      params.require(:user_prize).permit(:duration_left)
    end

    def user_have_enough_points?
      current_user.points > @prize.price
    end
  end
end
