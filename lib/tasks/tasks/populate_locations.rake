namespace :populate_locations do
  desc "Seed locations"

  task seeds: :environment do
    ActiveRecord::Base.transaction do
      populate_partners
      populate_locations
    end
  end

  private

  def populate_partners
    puts 'Populating partners...'
    5.times do |idx|
      Partner.create!(
        name: "Company #{idx}",
        points: rand(1..4) * 100
      )
    end
  end

  def populate_locations
    40.times do
      machine = Machine.create!(
        service_type: :travel,
        secret: '362bfb95773afcfd1e6c82fcce9e4a12',
        partner: Partner.all.sample
      )

      Location.create!(
        machine: machine,
        latitude: rand(51.66912222222..51.846845),
        longitude: rand(19.3305765..19.57322788),
        country: "Poland",
        city: "Lodz"
      )
    end
  end
end