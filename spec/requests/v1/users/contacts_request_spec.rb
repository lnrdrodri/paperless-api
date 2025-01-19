require 'rails_helper'

RSpec.describe 'Contacts Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(contact, contact_res)
    expect(contact_res['name']).to eq(contact.name)
    expect(contact_res['cnpj']).to eq(contact.cnpj)
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
      @contacts = create_list(:contact, @count)
      Contact.reindex
    end

    it 'should return all contacts' do
      get '/v1/users/contacts', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['contacts'].each do |contact_res|
        contact = @contacts.find { |contact| contact.id == contact_res['id'] }
        compare_default(contact, contact_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return contacts if not logged in' do
      get '/v1/users/contacts/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @contact_attr = attributes_for('contact')
    end

    it 'should create a contact and return it' do
      post '/v1/users/contacts', params: { contact: @contact_attr },
                                             headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(Contact.last, json['contact'])
    end

    it 'should not create a contact with contact not logged' do
      post '/v1/users/contacts', params: { contact: @contact_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @contact = create('contact')
    end

    it 'should return a contact' do
      get "/v1/users/contacts/#{@contact.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@contact, json['contact'])
    end

    it 'should not return a contact with contact not logged' do
      get "/v1/users/contacts/#{@contact.id}"

      without_login
    end

    it 'should not return a contact with resource id not exists' do
      get "/v1/users/contacts/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Contact not found')
    end
  end

  describe 'UPDATE' do
    before do
      @contact = create('contact')
      @contact_attr = attributes_for('contact')
    end

    it 'should update contact and return it' do
      put "/v1/users/contacts/#{@contact.id}", params: { contact: @contact_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@contact.reload, json['contact'])
      compare_attr(@contact_attr, @contact.reload)
    end

    it 'should not update contact with contact not logged' do
      put "/v1/users/contacts/#{@contact.id}", params: { contact: @contact_attr }

      without_login
    end

    it 'should not update contact with resource id not exists' do
      put "/v1/users/contacts/#{rand(1..999_999)}", params: { contact: @contact_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Contact not found')
    end
  end

  describe 'DESTROY' do
    before do
      @contact = create('contact')
    end

    it 'should destroy contact' do
      delete "/v1/users/contacts/#{@contact.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@contact.reload.is_deleted).to eq(true)
    end

    it 'should not destroy contact with contact not logged' do
      delete "/v1/users/contacts/#{@contact.id}"

      without_login
    end

    it 'should not destroy contact with resource id not exists' do
      delete "/v1/users/contacts/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Contact not found')
    end
  end
end
