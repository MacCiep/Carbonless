# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  lastname               :string           not null
#  name                   :string           not null
#  points                 :bigint           default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tgtg_active            :boolean          default(FALSE), not null
#  total_carbon_saved     :decimal(, )      default(0.0)
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
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenyList

  validates :name, :lastname, presence: true
  has_many :purchases
  has_many :history_points
  has_many :travel_sessions
  has_many :users_prizes
  has_many :prizes, through: :users_prizes
  has_many :achievements, through: :users_achievements
end
