require 'rails_helper'

RSpec.describe City, type: :model do
  let(:city) { create(:city) }

  it 'should create a city' do
    expect(city).to be_valid
  end
end
