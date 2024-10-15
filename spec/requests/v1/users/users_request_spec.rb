require 'rails_helper'

RSpec.describe 'Users Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(user, user_res)
    expect(user_res['name']).to eq(user.name)
    expect(user_res['email']).to eq(user.email)
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
      @users = create_list(:user, @count)
      User.reindex
    end

    it 'should return all users' do
      get '/v1/users/users', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['users'].each do |user_res|
        user = @users.find { |user| user.id == user_res['id'] }
        compare_default(user, user_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return users if not logged in' do
      get '/v1/users/users/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @user_attr = attributes_for('user')
    end

    it 'should create a user and return it' do
      post '/v1/users/users', params: { user: @user_attr },
                                             headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(User.last, json['user'])
    end

    it 'should not create a user with user not logged' do
      post '/v1/users/users', params: { user: @user_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @user = create('user')
    end

    it 'should return a user' do
      get "/v1/users/users/#{@user.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@user, json['user'])
    end

    it 'should not return a user with user not logged' do
      get "/v1/users/users/#{@user.id}"

      without_login
    end

    it 'should not return a user with resource id not exists' do
      get "/v1/users/users/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('User not found')
    end
  end

  describe 'UPDATE' do
    before do
      @user = create('user')
      @user_attr = attributes_for('user')
    end

    it 'should update user and return it' do
      put "/v1/users/users/#{@user.id}", params: { user: @user_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@user.reload, json['user'])
      compare_attr(@user_attr, @user.reload)
    end

    it 'should not update user with user not logged' do
      put "/v1/users/users/#{@user.id}", params: { user: @user_attr }

      without_login
    end

    it 'should not update user with resource id not exists' do
      put "/v1/users/users/#{rand(1..999_999)}", params: { user: @user_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('User not found')
    end
  end

  describe 'DESTROY' do
    before do
      @user = create('user')
    end

    it 'should destroy user' do
      delete "/v1/users/users/#{@user.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@user.reload.is_deleted).to eq(true)
    end

    it 'should not destroy user with user not logged' do
      delete "/v1/users/users/#{@user.id}"

      without_login
    end

    it 'should not destroy user with resource id not exists' do
      delete "/v1/users/users/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('User not found')
    end
  end
end
