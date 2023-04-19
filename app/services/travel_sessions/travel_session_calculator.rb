module TravelSessions
  class TravelSessionCalculator
    #Since distance is in meters, and we are assining 10 points per kilometer, multiplicator is set to 0.001
    TRAVEL_POINTS_MULTIPLICATOR = 0.01
    CARBON_DIOXIDE_PER_METER = 0.000121

    def initialize(distance)
      @distance = distance
    end

    def call
      { points: (@distance * TRAVEL_POINTS_MULTIPLICATOR).to_i, carbon_saved: (@distance * CARBON_DIOXIDE_PER_METER).round(2) }
    end
  end
end