
module V1
  module Users
    module Units
      class UnitsController < ApplicationController
        before_action :set_unit, only: %i[show update destroy]

        def index
          @units = Unit.search_default(
            params[:term] || '*',
            custom_params,
            params[:page],
            params[:term] ? false : true
          )
        end

        def create
          @unit = Unit.create(unit_params)

          return render json: { errors: @unit.errors.full_messages }, status: :unprocessable_entity unless @unit.valid?

          @unit
        end

        def show
          @unit
        end

        def update
          @unit.update(unit_params)

          return render json: { errors: @unit.errors.full_messages }, status: :unprocessable_entity unless @unit.valid?
        end

        def destroy
          @unit.update(is_deleted: true)

          render json: {}, status: 200
        end

        private

        def set_unit
          @unit = Unit.where(id: params[:id]).first

          if @unit.nil?
            render json: { error: 'Unit not found' }, status: 404
          end
        end

        def unit_params
          params.require(:unit).permit(
            :name, 
            :cnpj, 
            :status, 
            :success_percentage, 
            :royalts,
            :contact_id
          )
        end
      end
    end
  end
end