require 'rails_helper'

RSpec.describe "V1::Users::SessionsController", type: :request do
  describe 'CREATE' do
    let(:password) { Faker::Internet.password }
    let(:user) { create(:user, password: password) }

    context 'when user is not found' do
      it 'returns a 404 status with error message' do
        post '/v1/users/sessions', params: { email: Faker::Internet.email, password: }
        expect(response).to have_http_status(404)
        expect(json['error']).to eq('User not found')
      end
    end

    context 'when password is invalid' do
      it 'returns a 401 status with error message' do
        post '/v1/users/sessions', params: { email: user.email, password: Faker::Internet.password }

        expect(response).to have_http_status(401)
        expect(json['error']).to eq('Invalid password')
      end
    end

    context 'when credentials are valid' do
      it 'returns the user token' do
        post '/v1/users/sessions', params: { email: user.email, password: password }

        expect(response).to have_http_status(200)
        expect(json['token']).to eq(JWT.encode({user_id: user.id}, ENV['HASH_TOKEN']))
      end
    end
  end
end
