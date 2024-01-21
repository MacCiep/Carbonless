# frozen_string_literal: true

class ExchangeOfferPolicy < ApplicationPolicy
  def destroy?
    owner?
  end

  def accept?
    item_owner?
  end

  def reject?
    item_owner?
  end

  def complete?
    owner?
  end

  private

  def item_owner?
    @record.exchange_item.user_id == user.id
  end

  def owner?
    @record.user_id == user.id
  end
end
