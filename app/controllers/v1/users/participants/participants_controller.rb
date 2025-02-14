
module V1
  module Users
    module Participants
      class ParticipantsController < ApplicationController
        before_action :set_participant, only: %i[show update destroy]

        def index
          @participants = Participant.search_default(
            params[:term] || '*',
            custom_params,
            params[:page],
            params[:term] ? false : true
          )
        end

        def create
          @participant = Participant.create(participant_params)

          return render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity unless @participant.valid?

          @participant
        end

        def show
          @participant
        end

        def update
          @participant.update(participant_params)

          return render json: { errors: @participant.errors.full_messages }, status: :unprocessable_entity unless @participant.valid?
        end

        def destroy
          @participant.update(is_deleted: true)

          render json: {}, status: 200
        end

        private

        def set_participant
          @participant = Participant.where(id: params[:id]).first

          if @participant.nil?
            render json: { error: 'Participant not found' }, status: 404
          end
        end

        def participant_params
          params.require(:participant).permit(
            :name, 
            :cnpj, 
            :status, 
            :company_name,
            :document,
            :taxation_regime,
            :invoicing,
            :unit_id,
            :contact_id,
            :success_percentage,
            :royalts,
            addresses_attributes: %i[id street number neighborhood city_id zip_code _destroy])
        end
      end
    end
  end
end


