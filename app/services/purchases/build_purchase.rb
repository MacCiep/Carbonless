module Purchases
  class BuildPurchase
    def initialize(params, user)
      @machine_params = params.except(:points)
      @machine_uuid = machine_params[:uuid]
      @points = params[:points]
      @user = user
    end

    def call
      return unless Validator.new(machine_params, user).call

      user.purchases.build(machine: machine, purchase_type: machine.service_type_before_type_cast, points: points)
    end

    private

    attr_reader :machine_params, :machine_uuid, :points, :user

    def machine
      @machine ||= Machine.find_by(uuid: machine_uuid)
    end
  end
end