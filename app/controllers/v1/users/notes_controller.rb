
module V1
  module Users
    class NotesController < ApplicationController
      before_action :set_note, only: %i[show update destroy]

      def index
        @notes = Note.search_default(
          params[:term] || '*',
          custom_params,
          params[:page],
          params[:term] ? false : true
        )
      end

      def create
        @note = Note.create(make_params)
        return render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity unless @note.valid?
        @note
      end

      def show
        @note
      end

      def update
        @note.update(note_params)
        return render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity unless @note.valid?
      end

      def destroy
        @note.update(is_deleted: true)
        render json: {}, status: 200
      end

      private

      def make_params
        params_attr = note_params
        params_attr[:user_id] = @user.id
        params_attr
      end
      
      def set_note
        @note = Note.where(id: params[:id]).first
        if @note.nil?
          render json: { error: 'Note not found' }, status: 404
        end
      end

      def note_params
        params.require(:note).permit(
          :title,
          :content,
          :reference_type, 
          :reference_id, 
          )
      end
    end
  end
end


