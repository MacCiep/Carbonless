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

    # :reek:FeatureEnvy
    def scope_users
      users = User.all
      scope = params[:scope]
      scope_value = params[:scope_value]
      if scope_value.present?
        if scope == 'city'
          users = users.where(city: scope_value)
        elsif scope == 'country'
          users = users.where(country: scope_value)
        end
      end

      users.order(score: :desc).limit(5)
    end
  end
end
