FactoryBot.define do
  factory :purchase do
    machine
    user
    purchase_type { :food }
    points { Faker::Number.between(1, 100) }
  end
end