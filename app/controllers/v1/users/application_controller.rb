# frozen_string_literal: true

module V1
  module Users
    class ApplicationController < ApplicationController
      before_action :authorized
      
      def auth_header
        request.headers['Authorization']
      end

      def decoded_token
        if auth_header
          token = auth_header.split(' ')[1]
          begin
            JWT.decode(token, ENV['HASH_TOKEN'], true, algorithm: 'HS256')
          rescue JWT::DecodeError => e
            nil
          end
        end
      end

      def logged_in?
        return unless decoded_token

        user_id = decoded_token[0]['user_id']
        @user = User.where(id: user_id).first

        render json: { error: 'User not found' }, status: 404 unless @user
        true
      end

      def authorized
        unless logged_in?
          render json: {
            errors: 'User not logged'
          }, status: :unauthorized
        end
      end

      def encode_token(payload)
        JWT.encode(payload, ENV['HASH_TOKEN'])
      end
    end
  end
end