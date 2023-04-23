class SessionValidator
  private

  def call
    true if machine
  end

  def machine
    @machine ||= Machine.find_by(uuid: machine_uuid)
  end

  def encryptor
    ActiveSupport::MessageEncryptor.new(machine.secret)
  end

  def verification_time
    @verification_time ||= DateTime.now.in_time_zone("UTC")
  end
end