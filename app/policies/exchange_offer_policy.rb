class ExchangeOfferPolicy < ApplicationPolicy
  def create?
    is_not_owner_of_exchange_item?
  end

  def destroy?
    is_owner?
  end

  private

  def is_not_owner_of_exchange_item?
    @record.exchange_item.user_id != user.id
  end

  def is_owner?
    @record.user_id == user.id
  end
end