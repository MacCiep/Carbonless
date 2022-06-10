# frozen_string_literal: true

class CarbonSavingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_carbon_saving, only: %i[destroy show]

  def index
    @carbon_savings = CarbonSaving.all
    render json: @carbon_savings, status: :ok
  end

  def show
    @carbon_saving
  end

  def destroy
    if @carbon_saving.delete
      render status: :no_content
    else
      render json: @carbon_saving.errors.full_messages, status: :unprocessable_entity
    end
  end

  def create
    @carbon_saving = current_user.carbon_savings.new(carbon_saving_params)
    if @carbon_saving.save
      render json: @carbon_saving, status: :created
    else
      render json: @carbon_saving.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_carbon_saving
    @carbon_saving = CarbonSaving.find(params[:id])
  end

  def carbon_saving_params
    params.require(:carbon_saving).permit(:points)
  end
end
