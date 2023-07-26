class PointsHistoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: PointsHistory.where(user_id: current_user.id)
  end
end