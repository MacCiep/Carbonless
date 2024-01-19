# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    username { Faker::Name.first_name }
    password { 'Topsecret1*' }

    trait :business do
      user_type { :business }
    end
  end
end
