class BoardsController < ApplicationController

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
    
      private
    
      def board_params
        params.require(:board).permit(:title, :body, :board_image, :camera_make, :camera_model)
      end
end