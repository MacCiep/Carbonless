# frozen_string_literal: true

module Purchases
  class Handler
    def initialize(params, user, machine)
      @expires = params[:expires]
      @machine = machine
      @user = user
    end

    def call
      return Resonad.Failure('Request is invalid') unless Validator.new(machine, expires, user).call

      purchase = user.purchases.build(machine:)
      if purchase.save
        UserUpdater.new(user:, machine:).call
        Resonad.Success(PurchaseSerializer.new(purchase, user).call)
      else
        Resonad.Failure(purchase.errors.full_messages)
      end
    end

    private

    attr_reader :user, :machine, :expires
  end
end
