class StaticPagesController < ApplicationController
    skip_before_action :require_login, only: %i[top]
  
    def top
        # params[:q] が nil でない場合にのみ処理を行うようにする
        search_params = params[:q] || {}
        query_cont = search_params[:query_cont]
      
        @q = Board.ransack(
          camera_make_or_camera_model_cont: query_cont
        )
        @boards = @q.result(distinct: true).includes(:user, :camera).order(created_at: :desc).page(params[:page]).per(30)
      end
      
end
