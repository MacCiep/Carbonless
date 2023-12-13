module ErrorFormatable
  extend ActiveSupport::Concern

  def error
    error_message = @error.present? ? @error : ['Unknown error']
    error_message = error_message.is_a?(Array) ? error_message : [error_message]
    @error = { errors: error_message }
  end
end