require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:address) { create(:address) }

  it 'should create a address' do
    expect(address).to be_valid
  end
end
