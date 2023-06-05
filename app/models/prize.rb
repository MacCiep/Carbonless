# == Schema Information
#
# Table name: prizes
#
#  id       :bigint           not null, primary key
#  duration :integer          not null
#  price    :integer          not null
#  title    :string           not null
#  uuid     :uuid             not null
#
class Prize < ApplicationRecord
  validates :duration, :price, :title, presence: true
  validates :duration, :price, numericality: { greater_than: 0 }

  has_many :users_prizes
end
