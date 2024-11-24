class StaticPagesController < ApplicationController
    skip_before_action :require_login, only: %i[top]
  
    def top
      search_params = params[:q] || {}
      query_cont = search_params[:query_cont]
  
      # Ransackで検索結果を取得
      @q = Board.ransack(camera_make_or_camera_model_cont: query_cont)
  
      # 検索結果の総件数を取得
      @total_boards_count = @q.result(distinct: true).count
  
      # ページネーション用のデータを取得
      @boards = @q.result(distinct: true).includes(:user, :camera).order(created_at: :desc).page(params[:page]).per(30)
    end
  end
  