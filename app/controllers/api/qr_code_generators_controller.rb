# frozen_string_literal: true

module Api
  class QrCodeGeneratorsController < ApiController
    def show
      users_machine = current_user.machine
      return head :forbidden unless current_user.business? && users_machine

      expiration_date = ExpirationDateEncryptor.new(20.minutes.from_now, users_machine.secret).call

      render json: { expiration_date:, uuid: users_machine.uuid, type: users_machine.service_type },
             status: :ok
    end
  end
end
