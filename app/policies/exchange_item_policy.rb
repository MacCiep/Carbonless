# frozen_string_literal: true

class ExchangeItemPolicy < ApplicationPolicy
  def destroy?
    owner?
  end

  def update?
    owner?
  end

  def activate?
    owner?
  end

  def cancel?
    owner?
  end

  def exchange?
    owner?
  end

  def inactivate?
    owner?
  end

  private

  def owner?
    @record.user_id == user.id
  end
end
