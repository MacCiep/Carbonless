module Api
  class PointsHistoriesController < ApiController
    def index
      render json: PointsHistory.where(user_id: current_user.id)
    end
  end
end