# frozen_string_literal: true

module Api
  class MachinesController < ApiController
    def index
      @pagy, @collection = pagy(Machine.all)
      render json: paginated_response, status: :ok
    end

    def create
      machine = Machine.create(machine_params)
      if machine.save
        render json: machine, status: :created
      else
        render json: machine.errors.full_messages, status: :unprocessable_entity
      end
    end

    private

    def machine_params
      params.require(:machine).permit(:secret, :service_type, :uuid)
    end
  end
end
