ActiveRecord::Base.transaction do
[
  { email: 'phebe003@interia.pl', username: 'Kitka', user_type: :normal  },
  { email: 'test@test.com', username: 'Test', user_type: :normal  },
  { email: 'test1@test.com', username: 'Test1', user_type: :business }
].each do |user|
  User.create!(
    email: user[:email],
    username: user[:username],
    password: 'Test1234!',
    user_type: user[:user_type]
  )
end

[
  { email: 'phebe003@interia.pl' },
  { email: 'test@test.com' },
  { email: 'test1@test.com' },
].each do |admin|
  Admin.create!(
    email: admin[:email],
    password: 'Test1234!'
  )
end

partner_travel = Partner.create!(name: 'LocalTravel')
partner_shop = Partner.create!(name: 'LocalECOShop')

Machine.create!(secret: '362bfb95773afcfd1e6c82fcce9e4a12', service_type: :travel, partner: partner_travel )
shop_machine = Machine.create!(secret: '362bfb95773afcfd1e6c82fcce9e4a12', service_type: :purchase, partner: partner_shop)

(1..5).each do |idx|
  Prize.create!(price: 100, title: "Prize #{idx}", duration: idx, partner: partner_shop)
end

Location.create!(machine: shop_machine, latitude: '87.42', longitude: '32.231')
end