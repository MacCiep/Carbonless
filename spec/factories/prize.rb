# frozen_string_literal: true

FactoryBot.define do
  factory :prize do
    partner
    title { Faker::Name.name }
    duration { Faker::Number.between(from: 1, to: 100) }
    price { Faker::Number.between(from: 1, to: 100) }
    uuid { SecureRandom.uuid }
  end
end
