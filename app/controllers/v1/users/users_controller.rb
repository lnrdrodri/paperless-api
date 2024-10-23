
  module V1
    module Users
      class UsersController < ApplicationController
        before_action :set_user, only: %i[show update destroy]

        def index
          @users = User.search_default(
            params[:term] || '*',
            custom_params,
            params[:page],
            params[:term] ? false : true
          )
        end

        def create
          @user = User.create(user_params)

          return render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity unless @user.valid?

          @user
        end

        def show
          @user
        end

        def update
          @user.update(user_params)

          return render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity unless @user.valid?
        end

        def destroy
          @user.update(is_deleted: true)

          render json: {}, status: 200
        end

        private

        def set_user
          @user = User.where(id: params[:id]).first

          if @user.nil?
            render json: { error: 'User not found' }, status: 404
          end
        end

        def user_params
          params.require(:user).permit(:name, :email)
        end
      end
  end
end


