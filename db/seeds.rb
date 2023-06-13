ActiveRecord::Base.transaction do
[
  { email: 'phebe003@interia.pl', username: 'Kitka' },
  { email: 'test@test.com', username: 'Test' },
  { email: 'test1@test.com', username: 'Test1' },
].each do |user|
  User.create!(
    email: user[:email],
    username: user[:username],
    password: 'Test1234!'
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

(1..5).each do |idx|
  Prize.create!(price: 100, title: "Prize #{idx}", duration: idx)
end

partner_travel = Partner.create!(name: 'LocalTravel')
partner_shop = Partner.create!(name: 'LocalECOShop')

Machine.create!(secret: '362bfb95773afcfd1e6c82fcce9e4a12', service_type: :travel, partner: partner_travel )
Machine.create!(secret: '362bfb95773afcfd1e6c82fcce9e4a12', service_type: :purchase, points: 100, partner: partner_shop)

Location.create!(machine: Machine.second, latitude: '87.42', longitude: '32.231')
end