# frozen_string_literal: true

# :reek:TooManyInstanceVariables
class UserUpdater
  def initialize(user:, machine:, points: 0, carbon_saved: 0)
    @user = user
    @machine = machine
    @location = machine.location
    @points = points.zero? ? machine.partner.points : points
    @carbon_saved = carbon_saved
  end

  def call
    user.total_carbon_saved += carbon_saved
    user.points += points
    user.score += points
    user.country = location.country
    user.city = location.city
    user.save!
  end

  private

  attr_reader :user, :machine, :location, :points, :carbon_saved
end
