class UserUpdater
  def initialize(user:, points: 0, carbon_saved: 0)
    @user = user
    @points = points
    @carbon_saved = carbon_saved
  end

  def call
    user.total_carbon_saved += carbon_saved
    user.points += points
    user.save!
  end

  private

  attr_reader :user, :points, :carbon_saved
end