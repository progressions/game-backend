# app/controllers/api/v1/themes_controller.rb
module Api
  module V1
    class ThemesController < ApplicationController
      def index
        themes = Theme.all
        render json: themes
      end
    end
  end
end
