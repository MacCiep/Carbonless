# frozen_string_literal: true

module Api
  class QrCodeGeneratorsController < ApiController
    def show
      return head :forbidden unless current_user.business? && current_user.machine

      expiration_date = ExpirationDateEncryptor.new(20.minutes.from_now, current_user.machine.secret).call

      render json: { expiration_date:, uuid: current_user.machine.uuid, type: current_user.machine.service_type },
             status: :ok
    end
  end
end
