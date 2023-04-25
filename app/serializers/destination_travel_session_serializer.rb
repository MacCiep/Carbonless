class DestinationTravelSessionSerializer
  attr_reader :session_results, :user

  def initialize(session_results, user)
    @session_results = session_results
    @user = user
  end

  def call
    Jbuilder.new do |json|
      json.carbon_saved(user.total_carbon_saved.to_f.round(2))
      json.points(user.points)
      json.session_carbon_saved(session_results[:carbon_saved])
      json.session_points_saved(session_results[:points])
    end.attributes!
  end
end