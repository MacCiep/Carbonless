module Purchase
  class BuildPurchase
    PURCHASE_TIME_OFFSET = 12.hours

    def initialize(params, user)
      @machine_uuid = params[:uuid]
      @points = params[:points]
      @user = user
    end

    def call
      return unless machine || validate_purchase

      Purchase.build(machine: machine, points: @points, type: machine.service_type, user: @user)
    end

    private

    def machine
      @machine ||= Machine.find_by(uuid: @machine_uuid)
    end

    def validate_purchase
      @user.purchases.last.created_at > DateTime.now + PURCHASE_TIME_OFFSET
    end

    def purchase_type
      purchase_params[:type].constantize
    end
  end
end