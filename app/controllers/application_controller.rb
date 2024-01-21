# frozen_string_literal: true

class ApplicationController < ActionController::API
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json, :html

  private

  def configure_permitted_parameters
    added_attrs = %i[username email encrypted_password password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
