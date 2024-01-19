# frozen_string_literal: true

# == Schema Information
#
# Table name: partners
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  points      :integer          default(0), not null
#
class Partner < ApplicationRecord
  has_many :prize
  has_many :machines
  has_many :locations, through: :machines
  has_one_attached :logo
end
