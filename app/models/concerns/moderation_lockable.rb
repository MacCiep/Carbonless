# frozen_string_literal: true

module ModerationLockable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    include Devise::Models::Lockable

    def self.required_fields(klass)
      super(klass)
      attributes << :flagged_messages if klass.lock_strategy_enabled?(:flagged_messages)
    end

    def unlock_access!
      self.flagged_messages = 0 if respond_to?(:flagged_messages=)
      super
    end

    def valid_for_authentication?
      return super unless persisted? && lock_strategy_enabled?(:flagged_messages)

      return true if super && !access_locked?

      increment_flagged_messages
      if attempts_exceeded?
        lock_access! unless access_locked?
      else
        save(validate: false)
      end

      false
    end

    def attempts_exceeded?
      flagged_messages >= self.class.maximum_attempts
    end

    # rubocop:disable Rails/SkipsModelValidations
    def increment_flagged_messages
      self.class.increment_counter(:flagged_messages, id)
      reload
    end
    # rubocop:enable Rails/SkipsModelValidations

    def reset_flagged_messages!
      return unless respond_to?(:flagged_messages) && !flagged_messages.to_i.zero?

      self.flagged_messages = 0
      save(validate: false)
    end

    def access_locked?
      !!locked_at && !lock_expired?
    end
  end
  # rubocop:enable Metrics/BlockLength
end
