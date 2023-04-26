module Purchases
  class Validator < MachineValidator
    #TODO: Return to 12 hours
    TIME_BETWEEN_PURCHASES = 20.seconds
    EXPIRATION_TIME_LIMIT = 20.minutes

    def initialize(machine, expires, user)
      @machine = machine
      @expires = expires
      @user = user
    end

    def call
      validate_purchase_offset && validate_expiration_date
    end

    private

    attr_reader :machine, :user, :expires

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

      @user.purchases.last.created_at + TIME_BETWEEN_PURCHASES < verification_time
    end
  end
end