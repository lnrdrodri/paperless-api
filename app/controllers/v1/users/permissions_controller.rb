module V1
  module Users
    class PermissionsController < ApplicationController
      before_action :set_permission, only: %i[show update destroy]

      def index
        @permissions = Permission.search_default(
          params[:term] || '*',
          custom_params,
          params[:page],
          params[:term] ? false : true
        )
      end

      def create
        @permission = Permission.create(permission_params)

        return render json: { errors: @permission.errors.full_messages }, status: :unprocessable_entity unless @permission.valid?

        @permission
      end

      def show
        @permission
      end

      def update
        @permission.update(permission_params)

        return render json: { errors: @permission.errors.full_messages }, status: :unprocessable_entity unless @permission.valid?

        @permission
      end

      def destroy
        @permission.update(is_deleted: true)

        render json: {}, status: 200
      end

      private

      def set_permission
        @permission = Permission.where(id: params[:id]).first

        if @permission.nil?
          render json: { errors: 'Permission not found' }, status: 404
        end
      end

      def permission_params
        params.require(:permission).permit(:name, :description, :action)
      end
    end
  end
end

