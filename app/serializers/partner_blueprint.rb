class PartnerBlueprint < Blueprinter::Base

  fields :name

  view :with_locations do
    association :locations, blueprint: LocationBlueprint do |partner, options|
      partner.locations.with_nearby_machines(
        options[:latitude],
        options[:longitude],
        options[:range]) if options[:latitude] && options[:longitude]
    end
  end
end