# frozen_string_literal: true

FactoryBot.define do
  factory :users_prize do
    user
    prize
    active { true }
  end
end
