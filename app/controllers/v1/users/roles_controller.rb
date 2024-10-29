
module V1
  module Users
    class RolesController < ApplicationController
      before_action :set_role, only: %i[show update destroy]

      def index
        @roles = Role.search_default(
          params[:term] || '*',
          custom_params,
          params[:page],
          params[:term] ? false : true
        )
      end

      def create
        @role = Role.create(role_params)
        return render json: { errors: @role.errors.full_messages }, status: :unprocessable_entity unless @role.valid?
        @role
      end

      def show
        @role
      end

      def update
        @role.update(role_params)
        return render json: { errors: @role.errors.full_messages }, status: :unprocessable_entity unless @role.valid?
      end

      def destroy
        @role.update(is_deleted: true)
        render json: {}, status: 200
      end

      private
      
      def set_role
        @role = Role.where(id: params[:id]).first
        if @role.nil?
          render json: { error: 'Role not found' }, status: 404
        end
      end

      def role_params
        params.require(:role).permit(:name, :description, :is_active)
      end
    end
  end
end


