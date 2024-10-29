require 'rails_helper'

RSpec.describe 'Permissions Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(permission, permission_res)
    expect(permission.id).to eq(permission_res['id'])
    expect(permission.name).to eq(permission_res['name'])
    expect(permission.description).to eq(permission_res['description'])
    expect(permission.action).to eq(permission_res['action'])
    
  end

  describe 'INDEX' do
    before do
      @count = rand(1..5)
      @permission = create_list(:permission, @count)
      Permission.reindex
    end

    it 'should return all permissions' do
      get '/v1/users/permissions', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['permissions'].each do |permission_res|
        permission = @permission.find { |permission| permission.id == permission_res['id'] }
        compare_default(permission, permission_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return permissions if not logged in' do
      get '/v1/users/permissions'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @permission_attr = attributes_for(:permission)
    end

    it 'should create a permission and return it' do
      post '/v1/users/permissions', params: { permission: @permission_attr },
                                             headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(Permission.last, json['permission'])
    end

    it 'should not create a permission with user not logged' do
      post '/v1/users/permissions', params: { permission: @permission_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @permission = create(:permission)
    end

    it 'should return a permission' do
      get "/v1/users/permissions/#{@permission.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@permission, json['permission'])
    end

    it 'should not return a permission with user not logged' do
      get "/v1/users/permissions/#{@permission.id}"

      without_login
    end

    it 'should not return a permission with resource id not exists' do
      get "/v1/users/permissions/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['errors']).to eq('Permission not found')
    end
  end

  describe 'UPDATE' do
    before do
      @permission = create(:permission)
      @permission_attr = attributes_for(:permission)
    end

    it 'should update permission and return it' do
      put "/v1/users/permissions/#{@permission.id}", params: { permission: @permission_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(Permission.last, json['permission'])
    end

    it 'should not update permission with user not logged' do
      put "/v1/users/permissions/#{@permission.id}", params: { permission: @permission_attr }

      without_login
    end

    it 'should not update permission with resource id not exists' do
      put "/v1/users/permissions/#{rand(1..999_999)}", params: { permission: @permission_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['errors']).to eq('Permission not found')
    end
  end

  describe 'DESTROY' do
    before do
      @permission = create(:permission)
    end

    it 'should destroy permission' do
      delete "/v1/users/permissions/#{@permission.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(Permission.last.is_deleted).to eq(true)
    end

    it 'should not destroy permission with user not logged' do
      delete "/v1/users/permissions/#{@permission.id}"

      without_login
    end

    it 'should not destroy permission with resource id not exists' do
      delete "/v1/users/permissions/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['errors']).to eq('Permission not found')
    end
  end
end
