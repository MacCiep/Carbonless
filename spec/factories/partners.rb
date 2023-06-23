# == Schema Information
#
# Table name: partners
#
#  id     :bigint           not null, primary key
#  name   :string
#  points :integer          default(0), not null
#
FactoryBot.define do
  factory :partner do
    name { Faker::Company.name }
    points { 100 }
  end
end
