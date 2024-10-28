
require 'swagger_helper'

RSpec.describe 'Participants API' do
  include ModelsHelper
  path '/v1/users/participants' do
    get 'Retrieves all participants' do
      tags 'V1|Users|Participants|ParticipantsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :term,
                required: false,
                in: :query,
                type: :string,
                description: 'Term to search'

      response '200', 'participants found' do
          schema type: :object,
            properties: {
              participants: {
                type: 'array',
                items: {
                  allOf: [
                    { '$ref': partial_path },
                  ]
                }
              },
              total_count: { type: :integer },
              aggregators: 
          }

          run_test!
      end

      user_not_logged
    end

    post 'Create a participant' do
      tags 'V1|Users|Participants|ParticipantsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :participant,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    participant: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        cnpj: { type: :string },
                        status: { type: :integer },
                        addresses_attributes: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              street: { type: :string },
                              number: { type: :string },
                              neighborhood: { type: :string },
                              city_id: { type: :integer },
                              zip_code: { type: :string }
                            }
                        }
                      }
                    }
                  }
                }
              }

      response '200', 'Participant created' do
        schema type: :object,
          properties: {
            participant: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on create participant' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      user_not_logged
    end
  end

  path 'v1/users/participants/{participant_id}' do
      get 'Retrieves a participant' do
      tags 'V1|Users|Participants|ParticipantsResources'
      produces 'application/json'
      parameter name: :participant_id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'Participant found' do
        schema type: :object,
          properties: {
            participant: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Participant not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Participant not found'
          }

        run_test!
      end

      user_not_logged
    end

    put 'Update a participant' do
      tags 'V1|Users|Participants|ParticipantsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :participant_id,
                in: :path,
                type: :integer,
                required: true
      parameter name: :participant,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    participant: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        cnpj: { type: :string },
                        status: { type: :integer },
                        addresses_attributes: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              street: { type: :string },
                              number: { type: :string },
                              neighborhood: { type: :string },
                              city_id: { type: :integer },
                              zip_code: { type: :string }
                            }
                        }
                      }
                    }
                  }
                }
              }

      response '200', 'Participant updated' do
        schema type: :object,
          properties: {
            participant: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on update participant' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      response '404', 'Participant not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Participant not found'
          }

        run_test!
      end

      user_not_logged
    end

    delete 'Delete a participant' do
      tags 'V1|Users|Participants|ParticipantsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :participant_id,
                in: :path,
                type: :string,
                required: true

      response '200', 'Participant deleted' do
        schema type: :object,
          properties: {
            participant: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Participant not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Participant not found'
          }

        run_test!
      end

      user_not_logged
    end
  end
end