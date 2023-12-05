# == Schema Information
#
# Table name: exchange_offers
#
#  id               :bigint           not null, primary key
#  description      :text             not null
#  status           :integer          default("pending"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_item_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_exchange_offers_on_exchange_item_id  (exchange_item_id)
#  index_exchange_offers_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_item_id => exchange_items.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :exchange_offer do
    user
    exchange_item
    description { Faker::Lorem.paragraph }
    status { :pending }
  end
end
