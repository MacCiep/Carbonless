# frozen_string_literal: true

# == Schema Information
#
# Table name: partners
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  points      :integer          default(0), not null
#
class PartnerSerializer
  attr_reader :partner, :latitude, :longitude

  def initialize(partners, latitude: nil, longitude: nil)
    @partners = partners
    @latitude = latitude
    @longitude = longitude
  end

  # :reek:NestedIterators
  def call
    Jbuilder.new do |json|
      @partners.each do |_partner|
        json.name
        next unless latitude && longitude

        json.locations locations do |location|
          json.latitude location.latitude
          json.longitude location.longitude
        end
      end
    end
  end

  def locations
    partner.locations.with_nearby_machines(latitude, longitude).limit(15)
  end
end
