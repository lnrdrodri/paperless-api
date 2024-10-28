# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s



  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API GOLD VAULT',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: "http://#{ENV['HOST'] || 'localhost'}:#{ENV['PORT'] || '3000'}"
        }
      ],
      components: {
        schemas: all_models_with_attributes,
        partials: partials,
        securitySchemes: {
          user_auth_jwt: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT,
            in: :header
          },
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
