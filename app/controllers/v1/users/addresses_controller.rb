
module V1
  module Users
    class AddressesController < ApplicationController
      before_action :set_address, only: %i[show update destroy]

      def index
        @addresses = Address.search_default(
          params[:term] || '*',
          custom_params,
          params[:page],
          params[:term] ? false : true
        )
      end

      def create
        @address = Address.create(address_params)
        return render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity unless @address.valid?
        @address
      end

      def show
        @address
      end

      def update
        @address.update(address_params)
        return render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity unless @address.valid?
      end

      def destroy
        @address.update(is_deleted: true)
        render json: {}, status: 200
      end

      private
      
      def set_address
        @address = Address.where(id: params[:id]).first
        if @address.nil?
          render json: { error: 'Address not found' }, status: 404
        end
      end

      def address_params
        params.require(:address).permit(:reference_type, :reference_id, :street, :number, :complement, :neighborhood, :city_id, :zip_code)
      end
    end
  end
end


