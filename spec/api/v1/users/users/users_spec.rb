
require 'swagger_helper'

RSpec.describe 'Users API' do
  include ModelsHelper
  path '/v1/users/users' do
    get 'Retrieves all users' do
      tags 'V1|Users|Users|UsersResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :term,
                required: false,
                in: :query,
                type: :string,
                description: 'Term to search'

      response '200', 'users found' do
          schema type: :object,
            properties: {
              users: {
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

    post 'Create a user' do
      tags 'V1|Users|Users|UsersResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        email: { type: :string },
                    }
                  }
                }
              }

      response '200', 'User created' do
        schema type: :object,
          properties: {
            user: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on create user' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      user_not_logged
    end
  end

  path 'v1/users/users/{user_id}' do
      get 'Retrieves a user' do
      tags 'V1|Users|Users|UsersResources'
      produces 'application/json'
      parameter name: :user_id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'User found' do
        schema type: :object,
          properties: {
            user: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'User not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'User not found'
          }

        run_test!
      end

      user_not_logged
    end

    put 'Update a user' do
      tags 'V1|Users|Users|UsersResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :user_id,
                in: :path,
                type: :integer,
                required: true
      parameter name: :user,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        email: { type: :string },
                      }
                    }
                  }
                }

      response '200', 'User updated' do
        schema type: :object,
          properties: {
            user: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on update user' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      response '404', 'User not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'User not found'
          }

        run_test!
      end

      user_not_logged
    end

    delete 'Delete a user' do
      tags 'V1|Users|Users|UsersResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :user_id,
                in: :path,
                type: :string,
                required: true

      response '200', 'User deleted' do
        schema type: :object,
          properties: {
            user: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'User not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'User not found'
          }

        run_test!
      end

      user_not_logged
    end
  end
end