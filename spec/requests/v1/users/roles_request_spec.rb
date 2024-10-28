require 'rails_helper'

RSpec.describe 'Roles Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(role, role_res)
    expect(role.id).to eq(role_res['id'])
    expect(role.slug).to eq(role_res['slug'])
    expect(role.name).to eq(role_res['name'])
    expect(role.description).to eq(role_res['description'])
    expect(role.is_active).to eq(role_res['is_active'])
    expect(role.created_at.to_i).to eq(DateTime.parse(role_res['created_at']).to_i)
    expect(role.updated_at.to_i).to eq(DateTime.parse(role_res['updated_at']).to_i)
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
      @roles = create_list(:role, @count)
      Role.reindex
    end

    it 'should return all roles' do
      get '/v1/users/roles', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['roles'].each do |role_res|
        role = @roles.find { |role| role.id == role_res['id'] }
        compare_default(role, role_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return roles if not logged in' do
      get '/v1/users/roles/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @role_attr = attributes_for(:role)
    end

    it 'should create a role and return it' do
      post '/v1/users/roles', params: { role: @role_attr },
                                             headers: login_user(user)
                                             
      expect(response).to have_http_status(200)
      compare_default(Role.last, json['role'])
    end

    it 'should not create a role with role not logged' do
      post '/v1/users/roles', params: { role: @role_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @role = create(:role)
    end

    it 'should return a role' do
      get "/v1/users/roles/#{@role.id}", headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(@role, json['role'])
    end

    it 'should not return a role with role not logged' do
      get "/v1/users/roles/#{@role.id}"

      without_login
    end

    it 'should not return a role with resource id not exists' do
      get "/v1/users/roles/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Role not found')
    end
  end

  describe 'UPDATE' do
    before do
      @role = create(:role)
      @role_attr = attributes_for(:role)
    end

    it 'should update role and return it' do
      put "/v1/users/roles/#{@role.id}", params: { role: @role_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@role.reload, json['role'])
      compare_attr(@role_attr, @role.reload)
    end

    it 'should not update role with role not logged' do
      put "/v1/users/roles/#{@role.id}", params: { role: @role_attr }

      without_login
    end

    it 'should not update role with resource id not exists' do
      put "/v1/users/roles/#{rand(1..999_999)}", params: { role: @role_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Role not found')
    end
  end

  describe 'DESTROY' do
    before do
      @role = create(:role)
    end

    it 'should destroy role' do
      delete "/v1/users/roles/#{@role.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@role.reload.is_deleted).to eq(true)
    end

    it 'should not destroy role with role not logged' do
      delete "/v1/users/roles/#{@role.id}"

      without_login
    end

    it 'should not destroy role with resource id not exists' do
      delete "/v1/users/roles/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Role not found')
    end
  end
end

