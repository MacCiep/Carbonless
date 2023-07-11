# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action -> { request.session_options[:skip] = true }

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def show
    if current_user
      render json: current_user, status: :ok
    else
      head :unauthorized
    end
  end
  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    head :ok
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def verify_signed_out_user
    if all_signed_out?
      # set_flash_message! :notice, :already_signed_out
      # respond_to_on_destroy

      head :forbidden
    end
  end
end
