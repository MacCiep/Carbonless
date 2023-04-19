FactoryBot.define do
  factory :machine do
    secret { Faker::Crypto.sha256[0..31] }
    uuid { SecureRandom.uuid }
    service_type { :travel }

    trait :travel do
      service_type { :travel }
    end

    trait :clothes do
      service_type { :clothes }
    end

    trait :food do
      service_type { :food }
    end
  end
end
