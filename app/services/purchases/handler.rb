module Purchases
  class Handler
    def initialize(params, user, machine)
      @expires = params[:expires]
      @machine = machine
      @user = user
    end

    def call
      return Resonad.Failure('Request is invalid') unless Validator.new(machine, expires, user).call

      purchase = user.purchases.build(machine: machine, purchase_type: machine.service_type_before_type_cast, points: machine.points)
      if purchase.save
        UserUpdater.new(user: user, points: machine.points).call
        Resonad.Success(PurchaseSerializer.new(purchase, user).call)
      else
        Resonad.Failure(purchase.errors.full_messages)
      end
    end

    private

    attr_reader :user, :machine, :expires
  end
end