class ExchangeItemPolicy < ApplicationPolicy
  def destroy?
    is_owner?
  end

  def update?
    is_owner?
  end

  def activate?
    is_owner?
  end

  def cancel?
    is_owner?
  end

  def exchange?
    is_owner?
  end

  def inactivate?
    is_owner?
  end

  private

  def is_owner?
    @record.user_id == user.id
  end
end