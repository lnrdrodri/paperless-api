
require 'swagger_helper'

RSpec.describe 'Sessions API' do
  include ModelsHelper
  path '/v1/users/sessions' do
    post 'Create a session' do
      tags 'V1|Users|Sessions|SessionsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    password: { type: :string },
                }
              }

      response '200', 'Session created' do
        schema type: :object,
          properties: {
            token: {
              type: :string
            }
          }

        run_test!
      end

      response '401', 'Error on create user' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Invalid password'
          }
  
          run_test!
      end

      response '404', 'Session created' do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          example: {
            error: 'User not found'
          }
  
          run_test!
      end
    end
  end

  path '/v1/users/me' do
    get 'Get current user' do
      tags 'V1|Users|Sessions|SessionsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]

      response '200', 'User found' do
        schema type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                email: { type: :string }
              }
            }
          }

        run_test!
      end

      response '401', 'User not authenticated' do
        schema type: :object,
          properties: {
            error: { type: :string }
          },
          example: {
            error: 'User not authenticated'
          }
  
          run_test!
      end
    end
  end
end