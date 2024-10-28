require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { create(:role) }

  it 'should create a role' do
    expect(role).to be_valid
  end
end
