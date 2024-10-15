require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { create(:country) }

  it 'should create a country' do
    expect(country).to be_valid
  end
end
