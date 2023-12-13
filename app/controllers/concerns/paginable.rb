module Paginable
  extend ActiveSupport::Concern

  def paginated_response
    {
      records: @collection,
      metadata: pagy_metadata(@pagy)
    }
  end
end