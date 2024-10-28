
require 'swagger_helper'

RSpec.describe 'Units API' do
  include ModelsHelper
  path '/v1/users/units' do
    get 'Retrieves all units' do
      tags 'V1|Users|Units|UnitsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :term,
                required: false,
                in: :query,
                type: :string,
                description: 'Term to search'

      response '200', 'units found' do
          schema type: :object,
            properties: {
              units: {
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

    post 'Create a unit' do
      tags 'V1|Users|Units|UnitsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :unit,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    unit: {
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

      response '200', 'Unit created' do
        schema type: :object,
          properties: {
            unit: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on create unit' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      user_not_logged
    end
  end

  path 'v1/users/units/{unit_id}' do
      get 'Retrieves a unit' do
      tags 'V1|Users|Units|UnitsResources'
      produces 'application/json'
      parameter name: :unit_id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'Unit found' do
        schema type: :object,
          properties: {
            unit: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Unit not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Unit not found'
          }

        run_test!
      end

      user_not_logged
    end

    put 'Update a unit' do
      tags 'V1|Users|Units|UnitsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :unit_id,
                in: :path,
                type: :integer,
                required: true
      parameter name: :unit,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    unit: {
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

      response '200', 'Unit updated' do
        schema type: :object,
          properties: {
            unit: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on update unit' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      response '404', 'Unit not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Unit not found'
          }

        run_test!
      end

      user_not_logged
    end

    delete 'Delete a unit' do
      tags 'V1|Users|Units|UnitsResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :unit_id,
                in: :path,
                type: :string,
                required: true

      response '200', 'Unit deleted' do
        schema type: :object,
          properties: {
            unit: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Unit not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Unit not found'
          }

        run_test!
      end

      user_not_logged
    end
  end
end