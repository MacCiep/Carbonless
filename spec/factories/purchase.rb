FactoryBot.define do
  factory :purchase do
    machine
    user
    points { Faker::Number.between(1, 100) }
  end
end