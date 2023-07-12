class UserBlueprint < Blueprinter::Base
  view :high_score do
    fields :score, :username

    field :rank do |user, options|
      if options[:scope] == 'city' && options[:scope_value].present?
        user.city_rank(options[:scope_value])
      elsif options[:scope] == 'country' && options[:scope_value].present?
        user.country_rank(options[:scope_value])
      else
        user.global_rank
      end
    end

    field :leader_board do |_, options|
      options[:leaders]
    end
  end
end