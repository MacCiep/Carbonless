module Paginable
  extend ActiveSupport::Concern

  def paginated_response
    {
      records: @records,
      metadata: pagy_metadata(@pagy)
    }
  end
end