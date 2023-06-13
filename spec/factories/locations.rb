# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  machine_id :bigint           not null
#
# Indexes
#
#  index_locations_on_machine_id  (machine_id)
#
FactoryBot.define do
  factory :location do
    machine
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
