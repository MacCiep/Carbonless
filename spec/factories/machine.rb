FactoryBot.define do
  factory :machine do
    secret { Faker::Crypto.sha256[0..31] }
    uuid { SecureRandom.uuid }
    service_type { :travel }

    trait :travel do
      service_type { 0 }
    end

    trait :cloth do
      points { 100 }
      service_type { 1 }
    end

    trait :food do
      points { 50 }
      service_type { 2 }
    end
  end
end
