# == Schema Information
#
# Table name: partners
#
#  id   :bigint           not null, primary key
#  name :string
#
class Partner < ApplicationRecord
  has_many :prize
  has_many :machines
end
