class MachinesController < ApplicationController
  before_action :set_machine, only: %i[show update destroy]

  def index
    render json: paginated_response(Machine.all), status: :ok
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
    params.require(:machine).permit(:secret, :points, :service_type, :uuid)
  end

  def set_machine
    @machine = Machine.find(params[:id])
  end
end