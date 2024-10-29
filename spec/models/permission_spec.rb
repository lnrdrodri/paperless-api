require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:permission) { create(:permission) }

  it 'is valid with valid attributes' do
    expect(permission).to be_valid
  end
end
