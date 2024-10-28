require 'rails_helper'

RSpec.describe 'Participants Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(participant, participant_res)
    expect(participant_res['name']).to eq(participant.name)
    expect(participant_res['cnpj']).to eq(participant.cnpj)
  end

  def compare_attr(instance_attributes, instance)
    instance_attributes.each do |key, instance_attribute|
      if key.to_s.include?('_attributes')
        instance_attribute.each do |value|
          expect(!instance.send(key.to_s.split('_attributes')[0].nil?).as_json.find do |v|
                   v[value.as_json.keys[0]] == value.as_json.values[0]
                 end).to be_truthy
        end

        next
      end

      next if instance[key.to_s].instance_of?(ActiveSupport::TimeWithZone)

      if instance[key.to_s].is_a?(Numeric)
        expect(instance_attribute.to_s).to eq(instance[key.to_s].to_s)
        next
      end

      if instance[key.to_s].instance_of?(BigDecimal)
        expect(instance_attribute.to_f.round(2)).to eq(instance[key.to_s].to_f.round(2))
        next
      end

      expect(instance_attribute).to eq(instance[key.to_s])
    end
  end

  describe 'INDEX' do
    before do
      @count = rand(1..5)
      @participants = create_list(:participant, @count)
      Participant.reindex
    end

    it 'should return all participants' do
      get '/v1/users/participants', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['participants'].each do |participant_res|
        participant = @participants.find { |participant| participant.id == participant_res['id'] }
        compare_default(participant, participant_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return participants if not logged in' do
      get '/v1/users/participants/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @participant_attr = attributes_for(:participant)
      @participant_attr[:addresses_attributes] = [attributes_for(:address, reference_type: nil, reference_id: nil)]
    end

    it 'should create a participant and return it' do
      post '/v1/users/participants', params: { participant: @participant_attr },
                                             headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(Participant.last, json['participant'])
    end

    it 'should not create a participant with participant not logged' do
      post '/v1/users/participants', params: { participant: @participant_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @participant = create(:participant)
    end

    it 'should return a participant' do
      get "/v1/users/participants/#{@participant.id}", headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(@participant, json['participant'])
    end

    it 'should not return a participant with participant not logged' do
      get "/v1/users/participants/#{@participant.id}"

      without_login
    end

    it 'should not return a participant with resource id not exists' do
      get "/v1/users/participants/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Participant not found')
    end
  end

  describe 'UPDATE' do
    before do
      @participant = create(:participant)
      @participant_attr = attributes_for(:participant)
    end

    it 'should update participant and return it' do
      put "/v1/users/participants/#{@participant.id}", params: { participant: @participant_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@participant.reload, json['participant'])
      compare_attr(@participant_attr, @participant.reload)
    end

    it 'should not update participant with participant not logged' do
      put "/v1/users/participants/#{@participant.id}", params: { participant: @participant_attr }

      without_login
    end

    it 'should not update participant with resource id not exists' do
      put "/v1/users/participants/#{rand(1..999_999)}", params: { participant: @participant_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Participant not found')
    end
  end

  describe 'DESTROY' do
    before do
      @participant = create(:participant)
    end

    it 'should destroy participant' do
      delete "/v1/users/participants/#{@participant.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@participant.reload.is_deleted).to eq(true)
    end

    it 'should not destroy participant with participant not logged' do
      delete "/v1/users/participants/#{@participant.id}"

      without_login
    end

    it 'should not destroy participant with resource id not exists' do
      delete "/v1/users/participants/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Participant not found')
    end
  end
end
