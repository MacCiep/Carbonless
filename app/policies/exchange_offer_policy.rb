class ExchangeOfferPolicy < ApplicationPolicy
  def destroy?
    is_owner?
  end

  private

  def is_owner?
    @record.user_id == user.id
  end
end