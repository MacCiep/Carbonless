# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  def apply_filters
    @collection = @collection.where(attributes_filter_params) if attributes_filter_params.present?
  end

  def attributes_filter_params
    raise NotImplementedError
  end
end
