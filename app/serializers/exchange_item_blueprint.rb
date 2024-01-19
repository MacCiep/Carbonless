# frozen_string_literal: true

class ExchangeItemBlueprint < Blueprinter::Base
  fields :id, :name, :description, :created_at, :updated_at, :user_id
end
