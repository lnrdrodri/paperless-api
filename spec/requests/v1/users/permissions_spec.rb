require 'rails_helper'

RSpec.describe 'Permissions Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(permission, permission_res, attributes)
    
      expect(permission_res['is_deleted']).to eq(permission.is_deleted)
    
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
      @permission = create_list('permission', @count)
    end

    it 'should return all permissions' do
      get '/v1/users/', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['permissions'].each do |permission_res|
        permission = @permission.find { |permission| permission.id == permission_res['id'] }
        compare_default(permission, permission_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return permissions if not logged in' do
      get '/v1/users/'

      without_login('user')
    end
  end

  describe 'CREATE' do
    before do
      @permission_attr = attributes_for('permission')
    end

    it 'should create a permission and return it' do
      post '/v1/users/', params: { permission: @permission_attr },
                                             headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(Permission.last, json['permission'])
    end

    it 'should not create a permission with user not logged' do
      post '/v1/users/', params: { permission: @permission_attr }

      without_login('user')
    end
  end

  describe 'SHOW' do
    before do
      @permission = create('permission')
    end

    it 'should return a permission' do
      get "/v1/users/#{@permission.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@permission, json['permission'])
    end

    it 'should not return a permission with user not logged' do
      get "/v1/users/#{@permission.id}"

      without_login('user')
    end

    it 'should not return a permission with resource id not exists' do
      get "/v1/users/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['errors']).to eq('Permission not found')
    end
  end

  describe 'UPDATE' do
    before do
      @permission = create('permission')
      @permission_attr = attributes_for('permission')
    end

    it 'should update permission and return it' do
      put "/v1/users/#{@permission.id}", params: { permission: @permission_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(Permission.last, json['permission'])
    end

    it 'should not update permission with user not logged' do
      put "/v1/users/#{@permission.id}", params: { permission: @permission_attr }

      without_login('user')
    end

    it 'should not update permission with resource id not exists' do
      put "/v1/users/#{rand(1..999_999)}", params: { permission: @permission_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['errors']).to eq('Permission not found')
    end
  end

  describe 'DESTROY' do
    before do
      @permission = create('permission')
    end

    it 'should destroy permission' do
      delete "/v1/users/#{@permission.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(Permission.last.is_deleted).to eq(true)
    end

    it 'should not destroy permission with user not logged' do
      delete "/v1/users/#{@permission.id}"

      without_login('user')
    end

    it 'should not destroy permission with resource id not exists' do
      delete "/v1/users/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['errors']).to eq('Permission not found')
    end
  end
end
