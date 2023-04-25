class MachineValidator
  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(machine.secret)
  end

  def verification_time
    @verification_time ||= DateTime.now.in_time_zone("UTC")
  end
end