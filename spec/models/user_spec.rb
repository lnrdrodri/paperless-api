require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'should create a user' do
    expect(user).to be_valid
  end
end
