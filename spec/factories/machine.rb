FactoryBot.define do
  factory :machine do
    secret { Faker::Crypto.sha256[0..24] }
    uuid { SecureRandom.uuid }
    service_type { :travel }

    trait :travel do
      service_type { 0 }
    end

    trait :purchase do
      points { 100 }
      service_type { 1 }
    end
  end
end
