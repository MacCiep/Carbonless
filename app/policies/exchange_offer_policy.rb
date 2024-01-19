# frozen_string_literal: true

class ExchangeOfferPolicy < ApplicationPolicy
  def destroy?
    is_owner?
  end

  def accept?
    is_item_owner?
  end

  def reject?
    is_item_owner?
  end

  def complete?
    is_owner?
  end

  private

  def is_item_owner?
    @record.exchange_item.user_id == user.id
  end

  def is_owner?
    @record.user_id == user.id
  end
end
