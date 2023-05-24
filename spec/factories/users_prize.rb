FactoryBot.define do
  factory :users_prize do
    user
    prize
    active { true }
  end
end