class QrCodeGeneratorsController < ApplicationController
  before_action :authenticate_user!

  def show
    return head :forbidden unless current_user.business? && current_user.machine

    expiration_date = ExpirationDateEncryptor.new(Time.now + 20.minutes, current_user.machine.secret).call

    render json: { expiration_date: expiration_date, uuid: current_user.machine.uuid }, status: :ok
  end
end