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
      car_distance { Faker::Number.number(digits: 5)}
      active { false }
    end

    trait :completed do
      inactive
      car_distance { Faker::Number.number(digits: 5)}
      billet_id { Faker::Number.number(digits: 8) }
    end
  end
end