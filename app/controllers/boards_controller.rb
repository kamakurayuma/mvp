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
      
  
    private
  
    def set_board
      @board = Board.find(params[:id])
    end
  
    def board_params
      params.require(:board).permit(:title, :body, :board_image, :camera_make, :camera_model)
    end
  end
  