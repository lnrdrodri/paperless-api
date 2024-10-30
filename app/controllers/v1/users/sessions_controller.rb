# frozen_string_literal: true

module V1
  module Users
    class SessionsController < ApplicationController
      skip_before_action :authorized, only: [:create]
      
      def create
        @user = User.where(email: params[:email]).first
        if @user.nil?
          return render json: { error: 'User not found' }, status: 404
        end

        if !@user.authenticate(params[:password])
          return render json: { error: 'Invalid password' }, status: 404
        end

        render json: { token: encode_token({user_id: @user.id}) }, status: 200
      end

      def me 
        @user
      end
    end
  end
end
