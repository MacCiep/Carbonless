# frozen_string_literal: true

FactoryBot.define do
  factory :travel_session do
    user
    machine

    trait :active do
      start_latitude { Faker::Address.latitude }
      start_longitude { Faker::Address.longitude }
      active { true }
    end

    trait :inactive do
      active
      end_latitude { Faker::Address.latitude }
      end_longitude { Faker::Address.longitude }
      car_distance { Faker::Number.number(digits: 5) }
      active { false }
    end

    trait :completed do
      inactive
      success { true }
      car_distance { Faker::Number.number(digits: 5) }
    end
  end
end
