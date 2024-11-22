class BoardsController < ApplicationController
    before_action :set_board, only: [:edit, :update, :show, :destroy] 
  
    def index
    end
  
    def new
      @board = Board.new
    end
  
    def create
      @board = current_user.boards.build(board_params)
  
      if @board.save
        redirect_to root_path, success: '投稿しました'
      else
        flash.now[:danger] = '投稿に失敗しました'
        render :new, status: :unprocessable_entity
      end
    end
  
    def show
      # @board は set_board で設定されているので、ここでは何もする必要なし
    end
  
    def edit
      # @board は set_board で設定されているので、ここでは何もする必要なし
    end
  
    def update
      if @board.update(board_params)
        redirect_to @board, success: '投稿を更新しました'
      else
        flash.now[:danger] = '更新に失敗しました'
        render :edit
      end
    end
  
    def destroy
        @board.destroy
        redirect_to root_path, success: '投稿が削除されました'
    end
    
      # メーカーごとの投稿一覧
    def by_camera_make
        @make = params[:make]
        @boards = Board.where(camera_make: @make)
                       .order(created_at: :desc)  # 必要に応じて並べ替えを追加
                       .page(params[:page])       # ページネーションを追加
                       .per(30)   
    end

  # 機種ごとの投稿一覧
  def by_camera_model
    @model = params[:model]
    @boards = Board.where(camera_model: @model)
                   .order(created_at: :desc)  # 必要に応じて並べ替えを追加
                   .page(params[:page])       # ページネーションを追加
                   .per(30)                   # 1ページあたりの表示数を30に設定
  end
  
    private
  
    def set_board
      @board = Board.find(params[:id])
    end
  
    def board_params
      params.require(:board).permit(:title, :body, :board_image, :camera_make, :camera_model)
    end
  end
  