require 'rails_helper'

RSpec.describe ExchangeItem, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user).with_message('must exist') }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:name).is_at_most(80) }
    it { should validate_length_of(:description).is_at_most(300) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(inactive: 0, active: 1, cancelled: 2, exchanged: 3) }
  end
end