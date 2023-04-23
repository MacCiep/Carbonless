module Purchases
  class Validator < SessionValidator
    TIME_BETWEEN_PURCHASES = 12.hours
    EXPIRATION_TIME_LIMIT = 10.minutes

    def initialize(machine_params, user)
      @machine_uuid = machine_params[:uuid]
      @expires = machine_params[:expires]
      @user = user
    end

    def call
      return false unless super

      validate_purchase_offset && validate_expiration_date
    end

    private

    attr_reader :user, :machine_uuid, :expires

    def validate_expiration_date
      begin
        decrypted_expires = encryptor.decrypt_and_verify(expires)
      rescue ActiveSupport::MessageEncryptor::InvalidMessage
        return false
      end

      expires_date = decrypted_expires.to_datetime.in_time_zone("UTC")
      verification_time < expires_date && expires_date < verification_time + EXPIRATION_TIME_LIMIT
    end

    def validate_purchase_offset
      return true if @user.purchases.count.zero?

      @user.purchases.last.created_at > DateTime.now + TIME_BETWEEN_PURCHASES
    end
  end
end