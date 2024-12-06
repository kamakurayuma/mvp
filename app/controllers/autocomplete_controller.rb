class AutocompleteController < ApplicationController
    def index
      query = params[:query].downcase
      suggestions = CameraModel.where("name LIKE ?", "%#{query}%").pluck(:name)
      render json: suggestions
    end
end
  