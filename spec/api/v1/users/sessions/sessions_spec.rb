
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
                    name: { type: :string },
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
end