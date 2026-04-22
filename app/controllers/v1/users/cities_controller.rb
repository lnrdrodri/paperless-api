module V1
  module Users
    class CitiesController < ApplicationController
      def index
        @cities = City.search_default(
          params[:term] || '*',
          custom_params,
          params[:page],
          params[:term] ? false : true
        )
      end
    end
  end
end
