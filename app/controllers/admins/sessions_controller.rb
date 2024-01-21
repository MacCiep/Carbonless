# frozen_string_literal: true

module Admins
  class SessionsController < Devise::SessionsController
    include ActionController::RequestForgeryProtection
    include ActionController::Helpers
    include ActionController::Flash
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)

      yield resource if block_given?

      redirect_to after_sign_in_path_for(resource)
      # super
      # self.resource = warden.authenticate!(auth_options)
      # sign_in(resource_name, resource)
      # yield resource if block_given?
      # respond_with resource, location: after_sign_in_path_for(resource)
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    def after_sign_in_path_for(resource)
      admin_administrate_users_path(resource)
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
