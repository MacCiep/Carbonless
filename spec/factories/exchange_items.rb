# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_items
#
#  id          :bigint           not null, primary key
#  description :string(300)
#  name        :string(80)       not null
#  status      :integer          default("inactive")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_exchange_items_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :exchange_item do
    user
    name { Faker::Books.name }
    description { Faker::Lorem.paragraph }
    status { 0 }
  end
end
