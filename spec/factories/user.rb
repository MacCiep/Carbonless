FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    password         { "Topsecret1*"              }
  end
end