require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { create(:unit) }

  it 'is valid with valid attributes' do
    expect(unit).to be_valid
  end
end
