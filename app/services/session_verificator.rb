class SessionVerificator
  private

  def initialize(machine_params, current_session = nil)
    @uuid = machine_params[:uuid]
    @current_session = current_session
  end

  def call; end

  def machine
    @machine ||= Machine.find_by(uuid: uuid)
  end

  def encryptor
    ActiveSupport::MessageEncryptor.new(machine.secret)
  end
end