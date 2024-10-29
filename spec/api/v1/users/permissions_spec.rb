
require 'swagger_helper'

RSpec.describe 'Permissions API' do
  include ModelsHelper
  path '/v1/users/permissions' do
    get 'Retrieves all permissions' do
      tags 'V1|Users|Permissions|PermissionsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :term,
                required: false,
                in: :query,
                type: :string,
                description: 'Term to search'

      response '200', 'permissions found' do
          schema type: :object,
            properties: {
              permissions: {
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

    post 'Create a permission' do
      tags 'V1|Users|Permissions|PermissionsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :permission,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    permission: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        action: { type: :string },
                        description: { type: :string },
                      }
                    }
                  }
                }

      response '200', 'Permission created' do
        schema type: :object,
          properties: {
            permission: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on create permission' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      user_not_logged
    end
  end

  path 'v1/users/permissions/{permission_id}' do
      get 'Retrieves a permission' do
      tags 'V1|Users|Permissions|PermissionsResources'
      produces 'application/json'
      parameter name: :permission_id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'Permission found' do
        schema type: :object,
          properties: {
            permission: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Permission not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Permission not found'
          }

        run_test!
      end

      user_not_logged
    end

    put 'Update a permission' do
      tags 'V1|Users|Permissions|PermissionsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :permission_id,
                in: :path,
                type: :integer,
                required: true
      parameter name: :permission,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    permission: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        action: { type: :string },
                        description: { type: :string },
                      }
                    }
                  }
                }

      response '200', 'Permission updated' do
        schema type: :object,
          properties: {
            permission: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on update permission' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      response '404', 'Permission not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Permission not found'
          }

        run_test!
      end

      user_not_logged
    end

    delete 'Delete a permission' do
      tags 'V1|Users|Permissions|PermissionsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :permission_id,
                in: :path,
                type: :string,
                required: true

      response '200', 'Permission deleted' do
        schema type: :object,
          properties: {
            permission: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Permission not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Permission not found'
          }

        run_test!
      end

      user_not_logged
    end
  end
end