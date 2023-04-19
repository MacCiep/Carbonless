class CarbonSavingsController <ApplicationController
  def show
    render json: { carbon_saved: current_user.total_carbon_saved }
  end
end