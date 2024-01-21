# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  city                   :string
#  country                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  flagged_messages       :integer          default(0), not null
#  language               :integer          default("en"), not null
#  locked_at              :datetime
#  points                 :bigint           default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  score                  :integer          default(0)
#  theme                  :integer          default("light"), not null
#  total_carbon_saved     :decimal(, )      default(0.0)
#  unlock_token           :string
#  user_type              :integer          default("normal")
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  tgtg_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, :moderation_lockable,
         jwt_revocation_strategy: JwtDenyList

  validates :username, :theme, :language, presence: true
  has_many :purchases
  has_many :history_points
  has_many :travel_sessions
  has_many :users_prizes
  has_many :exchange_items
  has_many :exchange_offers
  has_one :machine
  # has_many :prizes, through: :users_prizes
  # has_many :users_achievements
  # has_many :achievements, through: :users_achievements

  def global_rank
    User.where('score > ?', score).count + 1
  end

  def country_rank(country)
    User.where(country:).where('score > ?', score).count + 1
  end

  def city_rank(city)
    User.where(city:).where('score > ?', score).count + 1
  end

  enum theme: {
    light: 0,
    dark: 1
  }

  enum language: {
    en: 0,
    pl: 1
  }

  enum user_type: {
    normal: 0,
    business: 1
  }
end
