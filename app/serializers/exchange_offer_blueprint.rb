class ExchangeOfferBlueprint < Blueprinter::Base
  fields :id, :description, :exchange_item_id, :user_id, :created_at, :updated_at
end