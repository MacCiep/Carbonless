class PurchasesController < ApplicationController
  def index
    render json: current_user.purchases
  end

  def create
    purchase = Purchase::BuildPurchase.new(purchase_params, current_user).call

    render json: { message: 'Purchase is not valid' }, status: :unprocessable_entity and return unless purchase

    if purchase.save!
      render json: purchase
    else
      render json: purchase.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:uuid, :expires, :points)
  end
end