
require 'swagger_helper'

RSpec.describe 'Addresses API' do
  include ModelsHelper
  path '/v1/users/addresses' do
    get 'Retrieves all addresses' do
      tags 'V1|Users|Addresses|AddressesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :term,
                required: false,
                in: :query,
                type: :string,
                description: 'Term to search'

      response '200', 'addresses found' do
          schema type: :object,
            properties: {
              addresses: {
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

    post 'Create a address' do
      tags 'V1|Users|Addresses|AddressesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :address,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    address: {
                      type: :object,
                      properties: {
                        reference_type: { type: :string },
                        reference_id: { type: :integer },
                        street: { type: :string },
                        number: { type: :string },
                        neighborhood: { type: :string },
                        zip_code: { type: :string },
                        city_id: { type: :integer },
                        city_name: { type: :string },
                        state_id: { type: :integer },
                        state_name: { type: :string },
                        country_id: { type: :integer },
                        country_name: { type: :string },
                      }
                    }
                  }
                }

      response '200', 'Address created' do
        schema type: :object,
          properties: {
            address: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on create address' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      user_not_logged
    end
  end

  path 'v1/users/addresses/{address_id}' do
      get 'Retrieves a address' do
      tags 'V1|Users|Addresses|AddressesResources'
      produces 'application/json'
      parameter name: :address_id,
                in: :path,
                type: :integer,
                required: true

      response '200', 'Address found' do
        schema type: :object,
          properties: {
            address: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Address not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Address not found'
          }

        run_test!
      end

      user_not_logged
    end

    put 'Update a address' do
      tags 'V1|Users|Addresses|AddressesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :address_id,
                in: :path,
                type: :integer,
                required: true
      parameter name: :address,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    address: {
                      type: :object,
                      properties: {
                        reference_type: { type: :string },
                        reference_id: { type: :integer },
                        street: { type: :string },
                        number: { type: :string },
                        neighborhood: { type: :string },
                        zip_code: { type: :string },
                        city_id: { type: :integer },
                        city_name: { type: :string },
                        state_id: { type: :integer },
                        state_name: { type: :string },
                        country_id: { type: :integer },
                        country_name: { type: :string },        
                      }
                    }
                  }
                }

      response '200', 'Address updated' do
        schema type: :object,
          properties: {
            address: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '400', 'Error on update address' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          }
  
          run_test!
      end

      response '404', 'Address not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Address not found'
          }

        run_test!
      end

      user_not_logged
    end

    delete 'Delete a address' do
      tags 'V1|Users|Addresses|AddressesResources'
      produces 'application/json'
      consumes 'application/json'
      security [user_auth_jwt: []]
      parameter name: :address_id,
                in: :path,
                type: :string,
                required: true

      response '200', 'Address deleted' do
        schema type: :object,
          properties: {
            address: {
              allOf: [
                { '$ref': partial_path },
              ]
            }
          }

        run_test!
      end

      response '404', 'Address not found' do
        schema type: :object,
          properties: {
            errors: { type: :string }
          },
          example: {
            errors: 'Address not found'
          }

        run_test!
      end

      user_not_logged
    end
  end
end