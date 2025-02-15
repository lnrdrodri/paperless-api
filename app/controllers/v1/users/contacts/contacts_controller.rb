module V1
  module Users
    module Contacts
      class ContactsController < ApplicationController
        before_action :set_contact, only: %i[show update destroy]

        def index
          @contacts = Contact.search_default(
            params[:term] || '*',
            custom_params,
            params[:page],
            params[:term] ? false : true
          )
        end

        def create
          @contact = Contact.create(contact_params)

          return render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity unless @contact.valid?

          @contact
        end

        def show
          @contact
        end

        def update
          @contact.update(contact_params)

          return render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity unless @contact.valid?
        end

        def destroy
          @contact.update(is_deleted: true)

          render json: {}, status: 200
        end

        private

        def set_contact
          @contact = Contact.where(id: params[:id]).first

          if @contact.nil?
            render json: { error: 'Contact not found' }, status: 404
          end
        end

        def contact_params
          params.require(:contact).permit(
            :name,
            :email,
            :mobile_phone,
            :position,
            :reference_type,
            :reference_id
          )
        end
      end
    end
  end
end




