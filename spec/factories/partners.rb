# == Schema Information
#
# Table name: partners
#
#  id   :bigint           not null, primary key
#  name :string
#
FactoryBot.define do
  factory :partner do
    name { Faker::Company.name }
  end
end
