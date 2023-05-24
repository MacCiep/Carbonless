FactoryBot.define do
  factory :prize do
    title { Faker::Name.name }
    duration { Faker::Number.between(1, 100) }
    price { Faker::Number.between(1, 100) }
    uuid { SecureRandom.uuid }
  end
end