# frozen_string_literal: true

FactoryBot.define do
  factory :machine do
    partner
    secret { Faker::Crypto.sha256[0..31] }
    uuid { SecureRandom.uuid }
    service_type { :travel }

    trait :travel do
      service_type { 0 }
    end

    trait :purchase do
      service_type { 1 }
    end
  end
end
