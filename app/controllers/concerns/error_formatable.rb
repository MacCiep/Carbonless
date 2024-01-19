# frozen_string_literal: true

module ErrorFormatable
  extend ActiveSupport::Concern

  def error
    error_message = (@error.presence || ['Unknown error'])
    error_message = [error_message] unless error_message.is_a?(Array)
    @error = { errors: error_message }
  end
end
