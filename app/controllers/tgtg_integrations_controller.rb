# frozen_string_literal: true

class TgtgIntegrationsController < ApplicationController
  def show
    result = TgtgMicroservice::Requests::AddOrderPoints.new(current_user).call
    if result.present?
      users_points = current_user.points + result
      current_user.update(points: users_points)
      render json: { points: users_points, added_points: result }, status: :ok
    else
      render json: { message: 'Something went wrong, please try another time' }, status: :unprocessable_entity
    end
  end

  def create
    response = TgtgMicroservice::Requests::Authorization.new(current_user).call
    if response.present?
      current_user.update(tgtg_id: response)
      render json: { message: 'User created, please check your email to accept connection' }, status: :created
    else
      render json: { message: 'Something went wrong, please try another time' }, status: :unprocessable_entity
    end
  end

  def update
    if TgtgMicroservice::Requests::RefreshAccess.new(current_user).call
      render json: { message: 'Check your email to accept connection' }, status: :ok
    else
      render json: { message: 'Something went wrong, please try another time' }, status: :unprocessable_entity
    end
  end

  # Implement logic related with refreshing token
  # def update
  # end
end
