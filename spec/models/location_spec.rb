# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  city       :string
#  country    :string
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  machine_id :bigint           not null
#
# Indexes
#
#  index_locations_on_machine_id  (machine_id)
#
require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "associations" do
    it { is_expected.to(belong_to(:machine)) }
    it { is_expected.to(have_one(:partner).through(:machine)) }
  end

  describe 'validations' do
    it { is_expected.to(validate_presence_of(:machine)) }
    it { is_expected.to(validate_presence_of(:latitude)) }
    it { is_expected.to(validate_presence_of(:longitude)) }
  end

  describe 'scopes' do
    context 'with_nearby_machines' do
      let!(:location) { create(:location, latitude: 70.0, longitude: 70.0) }

      context 'when latitude is too far' do
        it 'returns empty' do
          expect(Location.with_nearby_machines(70.2, 70.0)).to(be_empty)
        end

        it 'returns empty' do
          expect(Location.with_nearby_machines(69.8, 70.0)).to(be_empty)
        end
      end

      context 'when longitude is too far' do
        it 'returns empty' do
          expect(Location.with_nearby_machines(70.0, 70.2)).to(be_empty)
        end

        it 'returns empty' do
          expect(Location.with_nearby_machines(70.0, 69.8)).to(be_empty)
        end
      end

      context 'when latitude and longitude are within range' do
        it 'returns location' do
          expect(Location.with_nearby_machines(70.0901, 70.0901)).to(eq([location]))
        end

        it 'returns location' do
          expect(Location.with_nearby_machines(69.91, 69.91)).to(eq([location]))
        end
      end
    end
  end
end
