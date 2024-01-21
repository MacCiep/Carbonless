# frozen_string_literal: true

class PartnerBlueprint < Blueprinter::Base
  fields :name, :description

  field :logo do |partner|
    partner.logo.service_url if partner.logo.attached?
  end

  view :with_locations do
    association :locations, blueprint: LocationBlueprint do |partner, options|
      if options[:latitude] && options[:longitude]
        partner.locations.with_nearby_machines(
          options[:latitude],
          options[:longitude],
          options[:range]
        )
      end
    end
  end
end
