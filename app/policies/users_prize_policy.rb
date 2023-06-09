class UsersPrizePolicy < ApplicationPolicy
  def update?
    user.business? && @record.active? && duration_left?
  end

  def show?
    user.business?
  end

  private

  def duration_left?
    (@record.created_at + @record.duration.days).in_time_zone("UTC") > DateTime.now.in_time_zone("UTC")
  end
end