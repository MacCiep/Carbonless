# frozen_string_literal: true

module Api
  class HighScoresController < ApiController
    def index
      render json: UserBlueprint.render_as_hash(
        current_user,
        view: :high_score,
        leaders: scope_users,
        scope: params[:scope],
        scope_value: params[:scope_value]
      )
    end

    private

    def scope_users
      users = User
      if params[:scope] == 'city' && params[:scope_value].present?
        users = users.where(city: params[:scope_value])
      elsif params[:scope] == 'country' && params[:scope_value].present?
        users = users.where(country: params[:scope_value])
      end

      users.order(score: :desc).limit(5)
    end
  end
end
