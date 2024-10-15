require 'rails_helper'

RSpec.describe State, type: :model do
  let(:state) { create(:state) }

  it 'should create a state' do
    expect(state).to be_valid
  end
end
