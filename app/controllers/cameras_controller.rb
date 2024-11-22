class CamerasController < ApplicationController
    def create
      @camera = Camera.new(camera_params)
      if @camera.save
        render json: { status: 'success', message: 'カメラモデルが保存されました' }, status: :created
      else
        render json: { status: 'error', message: @camera.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def suggest
      @cameras = Camera.where("make LIKE ?", "%#{params[:make]}%")
      render json: @cameras
    end

    def search
        # クエリパラメータに基づいてカメラを検索
        @results = Camera.where('make LIKE ? OR model LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
    end
  
    private
  
    def camera_params
      params.require(:camera).permit(:make, :model)
    end
end
  