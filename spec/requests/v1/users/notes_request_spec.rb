require 'rails_helper'

RSpec.describe 'Notes Request', type: :request do
  include RequestSpecHelper
  let(:user) { create(:user) }

  def compare_default(note, note_res)
    expect(note.id).to eq(note_res['id'])
    expect(note.title).to eq(note_res['title'])
    expect(note.content).to eq(note_res['content'])
    expect(note.reference_type).to eq(note_res['reference_type'])
    expect(note.reference_id).to eq(note_res['reference_id'])
    expect(note.created_at.to_i).to eq(DateTime.parse(note_res['created_at']).to_i)
    expect(note.updated_at.to_i).to eq(DateTime.parse(note_res['updated_at']).to_i)
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
      @notes = create_list(:note, @count, user_id: user.id)
      Note.reindex
    end

    it 'should return all notes' do
      get '/v1/users/notes', headers: login_user(user)

      expect(response).to have_http_status(200)

      json['notes'].each do |note_res|
        note = @notes.find { |note| note.id == note_res['id'] }
        compare_default(note, note_res)
      end
      expect(json['total_count']).to eq(@count)
    end

    it 'should not return notes if not logged in' do
      get '/v1/users/notes/'

      without_login
    end
  end

  describe 'CREATE' do
    before do
      @note_attr = attributes_for(:note, user_id: user.id)
    end

    it 'should create a note and return it' do
      post '/v1/users/notes', params: { note: @note_attr },
                                             headers: login_user(user)
                                             
      expect(response).to have_http_status(200)
      compare_default(Note.last, json['note'])
    end

    it 'should not create a note with note not logged' do
      post '/v1/users/notes', params: { note: @note_attr }

      without_login
    end
  end

  describe 'SHOW' do
    before do
      @note = create(:note, user_id: user.id)
    end

    it 'should return a note' do
      get "/v1/users/notes/#{@note.id}", headers: login_user(user)
      expect(response).to have_http_status(200)
      compare_default(@note, json['note'])
    end

    it 'should not return a note with note not logged' do
      get "/v1/users/notes/#{@note.id}"

      without_login
    end

    it 'should not return a note with resource id not exists' do
      get "/v1/users/notes/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Note not found')
    end
  end

  describe 'UPDATE' do
    before do
      @note = create(:note, user_id: user.id)
      @note_attr = attributes_for(:note, user_id: user.id)
    end

    it 'should update note and return it' do
      put "/v1/users/notes/#{@note.id}", params: { note: @note_attr },
                                                         headers: login_user(user)

      expect(response).to have_http_status(200)
      compare_default(@note.reload, json['note'])
      compare_attr(@note_attr, @note.reload)
    end

    it 'should not update note with note not logged' do
      put "/v1/users/notes/#{@note.id}", params: { note: @note_attr }

      without_login
    end

    it 'should not update note with resource id not exists' do
      put "/v1/users/notes/#{rand(1..999_999)}", params: { note: @note_attr },
                                                            headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Note not found')
    end
  end

  describe 'DESTROY' do
    before do
      @note = create(:note, user_id: user.id)
    end

    it 'should destroy note' do
      delete "/v1/users/notes/#{@note.id}", headers: login_user(user)

      expect(response).to have_http_status(200)
      expect(@note.reload.is_deleted).to eq(true)
    end

    it 'should not destroy note with note not logged' do
      delete "/v1/users/notes/#{@note.id}"

      without_login
    end

    it 'should not destroy note with resource id not exists' do
      delete "/v1/users/notes/#{rand(1..999_999)}", headers: login_user(user)

      expect(response).to have_http_status(404)
      expect(json['error']).to eq('Note not found')
    end
  end
end

