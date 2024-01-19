# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    # My custom action
    def show; end
    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    # def create
    #   super
    # end

    # GET /resource/password/edit?reset_password_token=abcdef

    # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)

        set_flash_message!(:notice, :updated_not_active)
        redirect_to users_passwords_success_path
      else
        set_minimum_password_length
        respond_with resource
      end
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
