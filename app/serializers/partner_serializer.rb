# == Schema Information
#
# Table name: partners
#
#  id     :bigint           not null, primary key
#  name   :string
#  points :integer          default(0), not null
#
class PartnerSerializer
  attr_reader :partner, :latitude, :longitude

  def initialize(partners, latitude: nil, longitude: nil)
    @partners = partners
    @latitude = latitude
    @longitude = longitude
  end

  def call
    Jbuilder.new do |json|
      @partners.each do |partner|
        json.name
        if latitude && longitude
          json.locations locations do |location|
            json.latitude location.latitude
            json.longitude location.longitude
          end
        end
      end
    end
  end

  def locations
    partner.locations.with_nearby_machines(latitude, longitude).limit(15)
  end
end
