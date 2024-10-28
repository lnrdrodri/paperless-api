require 'rails_helper'

RSpec.describe 'Units Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(unit, unit_res)
    expect(unit_res['name']).to eq(unit.name)
    expect(unit_res['cnpj']).to eq(unit.cnpj)
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
      @units = create_list(:unit, @count)
      Unit.reindex
    end

    it 'should return all units' do
      get '/v1/users/units', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['units'].each do |unit_res|
        unit = @units.find { |unit| unit.id == unit_res['id'] }
        compare_default(unit, unit_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return units if not logged in' do
      get '/v1/users/units/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @unit_attr = attributes_for(:unit)
      @unit_attr[:addresses_attributes] = [attributes_for(:address, reference_type: nil, reference_id: nil)]
    end

    it 'should create a unit and return it' do
      post '/v1/users/units', params: { unit: @unit_attr },
                                             headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(Unit.last, json['unit'])
    end

    it 'should not create a unit with unit not logged' do
      post '/v1/users/units', params: { unit: @unit_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @unit = create(:unit)
    end

    it 'should return a unit' do
      get "/v1/users/units/#{@unit.id}", headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(@unit, json['unit'])
    end

    it 'should not return a unit with unit not logged' do
      get "/v1/users/units/#{@unit.id}"

      without_login
    end

    it 'should not return a unit with resource id not exists' do
      get "/v1/users/units/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Unit not found')
    end
  end

  describe 'UPDATE' do
    before do
      @unit = create(:unit)
      @unit_attr = attributes_for(:unit)
    end

    it 'should update unit and return it' do
      put "/v1/users/units/#{@unit.id}", params: { unit: @unit_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@unit.reload, json['unit'])
      compare_attr(@unit_attr, @unit.reload)
    end

    it 'should not update unit with unit not logged' do
      put "/v1/users/units/#{@unit.id}", params: { unit: @unit_attr }

      without_login
    end

    it 'should not update unit with resource id not exists' do
      put "/v1/users/units/#{rand(1..999_999)}", params: { unit: @unit_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Unit not found')
    end
  end

  describe 'DESTROY' do
    before do
      @unit = create(:unit)
    end

    it 'should destroy unit' do
      delete "/v1/users/units/#{@unit.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@unit.reload.is_deleted).to eq(true)
    end

    it 'should not destroy unit with unit not logged' do
      delete "/v1/users/units/#{@unit.id}"

      without_login
    end

    it 'should not destroy unit with resource id not exists' do
      delete "/v1/users/units/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Unit not found')
    end
  end
end

