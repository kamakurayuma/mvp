class CamerasController < ApplicationController
  # 新しいカメラモデルを保存
  def create
    @camera = Camera.new(camera_params)
    
    # カメラモデルが保存されるか確認
    if @camera.save
      render json: { status: 'success', message: 'カメラモデルが保存されました' }, status: :created
    else
      render json: { status: 'error', message: @camera.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # カメラのメーカーに基づいてサジェストを返す
  def suggest
    # 検索条件（make）を部分一致で検索
    @cameras = Camera.where("make LIKE ?", "%#{params[:make]}%")
    render json: @cameras
  end

  # 検索クエリ（makeやmodel）に基づいてカメラを検索
  def search
    @results = Camera.where('make LIKE ? OR model LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
    render json: @results
  end

  private

  # Strong parameters（保存するパラメータの定義）
  def camera_params
    params.require(:camera).permit(:make, :model)
  end
end
