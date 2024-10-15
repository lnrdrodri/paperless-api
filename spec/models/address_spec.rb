require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { create(:address) }

  it 'should create an address' do
    expect(address).to be_valid
  end
end
