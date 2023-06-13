# frozen_string_literal: true

require 'devise/jwt/test_helpers'

module ApiHelper
  def authenticated_headers(headers, user)
    Devise::JWT::TestHelpers.auth_headers(headers, user, scope: :user)
  end
end
