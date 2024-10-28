require 'rails_helper'

RSpec.describe 'Addresses Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(address, address_res)
    expect(address.id).to eq(address_res['id'])
    expect(address.reference_type).to eq(address_res['reference_type'])
    expect(address.reference_id).to eq(address_res['reference_id'])
    expect(address.street).to eq(address_res['street'])
    expect(address.number).to eq(address_res['number'])
    expect(address.complement).to eq(address_res['complement'])
    expect(address.neighborhood).to eq(address_res['neighborhood'])
    expect(address.city_id).to eq(address_res['city_id'])
    expect(address.zip_code).to eq(address_res['zip_code'])
    expect(address.created_at.to_i).to eq(DateTime.parse(address_res['created_at']).to_i)
    expect(address.updated_at.to_i).to eq(DateTime.parse(address_res['updated_at']).to_i)
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
      @addresses = create_list(:address, @count)
      Address.reindex
    end

    it 'should return all addresses' do
      get '/v1/users/addresses', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['addresses'].each do |address_res|
        address = @addresses.find { |address| address.id == address_res['id'] }
        compare_default(address, address_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return addresses if not logged in' do
      get '/v1/users/addresses/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @address_attr = attributes_for(:address)
    end

    it 'should create a address and return it' do
      post '/v1/users/addresses', params: { address: @address_attr },
                                             headers: login_user(user)
                                             
      expect(response).to have_http_status(200)
      compare_default(Address.last, json['address'])
    end

    it 'should not create a address with address not logged' do
      post '/v1/users/addresses', params: { address: @address_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @address = create(:address)
    end

    it 'should return a address' do
      get "/v1/users/addresses/#{@address.id}", headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(@address, json['address'])
    end

    it 'should not return a address with address not logged' do
      get "/v1/users/addresses/#{@address.id}"

      without_login
    end

    it 'should not return a address with resource id not exists' do
      get "/v1/users/addresses/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Address not found')
    end
  end

  describe 'UPDATE' do
    before do
      @address = create(:address)
      @address_attr = attributes_for(:address)
    end

    it 'should update address and return it' do
      put "/v1/users/addresses/#{@address.id}", params: { address: @address_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@address.reload, json['address'])
      compare_attr(@address_attr, @address.reload)
    end

    it 'should not update address with address not logged' do
      put "/v1/users/addresses/#{@address.id}", params: { address: @address_attr }

      without_login
    end

    it 'should not update address with resource id not exists' do
      put "/v1/users/addresses/#{rand(1..999_999)}", params: { address: @address_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Address not found')
    end
  end

  describe 'DESTROY' do
    before do
      @address = create(:address)
    end

    it 'should destroy address' do
      delete "/v1/users/addresses/#{@address.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@address.reload.is_deleted).to eq(true)
    end

    it 'should not destroy address with address not logged' do
      delete "/v1/users/addresses/#{@address.id}"

      without_login
    end

    it 'should not destroy address with resource id not exists' do
      delete "/v1/users/addresses/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Address not found')
    end
  end
end

