
require 'swagger_helper'

RSpec.describe 'Roles API' do
  include ModelsHelper
  path '/v1/users/roles' do
    get 'Retrieves all roles' do
      tags 'V1|Users|Roles|RolesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :term,
                required: false,
                in: :query,
                type: :string,
                description: 'Term to search'

      response '200', 'roles found' do
          schema type: :object,
            properties: {
              roles: {
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

    post 'Create a role' do
      tags 'V1|Users|Roles|RolesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :role,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    role: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        slug: { type: :string },
                        description: { type: :string },
                        is_active: { type: :boolean }
                      }
                    }
                  }
                }

      response '200', 'Role created' do
        schema type: :object,
          properties: {
            role: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on create role' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      user_not_logged
    end
  end

  path 'v1/users/roles/{role_id}' do
      get 'Retrieves a role' do
      tags 'V1|Users|Roles|RolesResources'
      produces 'application/json'
      parameter name: :role_id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'Role found' do
        schema type: :object,
          properties: {
            role: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Role not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Role not found'
          }

        run_test!
      end

      user_not_logged
    end

    put 'Update a role' do
      tags 'V1|Users|Roles|RolesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :role_id,
                in: :path,
                type: :integer,
                required: true
      parameter name: :role,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    role: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        slug: { type: :string },
                        description: { type: :string },
                        is_active: { type: :boolean }       
                      }
                    }
                  }
                }

      response '200', 'Role updated' do
        schema type: :object,
          properties: {
            role: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on update role' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      response '404', 'Role not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Role not found'
          }

        run_test!
      end

      user_not_logged
    end

    delete 'Delete a role' do
      tags 'V1|Users|Roles|RolesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :role_id,
                in: :path,
                type: :string,
                required: true

      response '200', 'Role deleted' do
        schema type: :object,
          properties: {
            role: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Role not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Role not found'
          }

        run_test!
      end

      user_not_logged
    end
  end
end