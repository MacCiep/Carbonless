module UsersPrizes
  class ValidateUserPrize
    def initialize(user_prize)
      @user_prize = user_prize
    end

    def call
      active? && duration_left?
    end

    private

    def active?
      @user_prize.active?
    end

    def duration_left?
      (@user_prize.created_at + @user_prize.duration.days).in_time_zone("UTC") > DateTime.now.in_time_zone("UTC")
    end
  end
end