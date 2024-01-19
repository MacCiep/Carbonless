# frozen_string_literal: true

class GrandAchievementsJob < ApplicationJob
  queue_as :default

  def perform(*args); end
end
