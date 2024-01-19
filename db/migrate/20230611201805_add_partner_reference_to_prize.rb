# frozen_string_literal: true

class AddPartnerReferenceToPrize < ActiveRecord::Migration[5.2]
  def change
    add_reference :prizes, :partner, foreign_key: true, null: false
  end
end
