class BoardsController < ApplicationController
    before_action :set_board, only: [:edit, :update, :show, :destroy] 


    def index
      @boards = @user.boards.order(created_at: :desc) 
    end
  
    def new
      @board = Board.new
      @camera_makes = ['Canon', 'Nikon', 'Sony', 'Panasonic']  
    end

    def show
      @board = Board.find(params[:id])

    end
  
    def create
      @board = Board.new(board_params)
      @board.user = current_user 
    
      if @board.board_image.present?
        @board.board_image_url = @board.board_image.url 
      end
    
      if @board.save
        if params[:board][:camera_model] == "その他" && params[:board][:custom_camera_make].present?
          CameraModel.create(name: params[:board][:custom_camera_make])
        end
    
        redirect_to root_path, success: '投稿しました'
      else
        flash.now[:danger] = '投稿に失敗しました'
        render :new, status: :unprocessable_entity
      end
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

    def bookmarks
      @bookmark_boards = current_user.bookmark_boards
                                     .includes(:user)
                                     .order('bookmarks.created_at DESC')
                                     .page(params[:page])
                                     .per(30)
    end

    def like
      @board = Board.find(params[:id])
      @board.increment!(:likes_count) 
    
      respond_to do |format|
        format.html { redirect_to @board }
        format.json { render json: { board_id: @board.id, likes_count: @board.likes_count.to_i } } 
      end
    end
    
def by_camera_make
  @make = params[:make]  
  @custom_make = params[:custom_camera_make]  

  @page_title = if @make == 'その他' && @custom_make.present?
                  @custom_make 
                elsif @make == 'その他'
                  'その他'   
                else
                  @make     
                end

  if @make == 'その他' && @custom_make.present?
    @boards = Board.where('LOWER(camera_make) = ? AND LOWER(custom_camera_make) = ?', @make.downcase, @custom_make.downcase)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(30)
  else
    @boards = Board.where('LOWER(camera_make) = ?', @make.downcase)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(30)
  end
end

  def by_camera_model
    @model = params[:model]


    @boards = Board.where(camera_model: @model)
                   .order(created_at: :desc)  
                   .page(params[:page])      
                   .per(30)                 
  end

  def edit
    @board = Board.find(params[:id])
    @camera_makes = Camera.distinct.pluck(:make) 
  end

  def search
    query = params.dig(:q, :query_cont) || ""
    if request.format.json?
      @q = Board.ransack(camera_make_or_camera_model_cont: query)
      @boards = @q.result(distinct: true).select(:id, :camera_make, :camera_model)
      render json: @boards.map { |item| { name: "#{item.camera_make} #{item.camera_model}" } }
    else
      @q = Board.ransack(camera_make_or_camera_model_cont: query)
      @boards = @q.result(distinct: true).includes(:user, :camera).order(created_at: :desc).page(params[:page]).per(30)
    end
  end

  def autocomplete
    type = params[:type]
    query = params[:query].downcase 
    fixed_makers = ['Canon', 'Nikon', 'Sony', 'Fujifilm', 'Panasonic', 'Olympus', 'Ricoh', 'Casio', 'Minolta', 'Leica', 'Pentax', 'Kodak', 'Samsung', 'Vivitar', 'Toshiba', 'Yashica', 'Konica', 'Agfa', 'Zenit', 'Voigtländer', 'Polaroid', 'Rollei', 'Minox']    
    make_results = []
    model_results = []
  
    make_results = Board.where('LOWER(camera_make) LIKE ? AND camera_make != ?', 
                                "%#{query}%", "不明")
                         .pluck(:camera_make)
                         .uniq
  
    model_results = Board.where('LOWER(camera_model) LIKE ? AND camera_make != ?', 
                                 "%#{query}%", "不明")
                          .pluck(:camera_model)
                          .uniq

    results = make_results + model_results
    results.concat(fixed_makers.select { |maker| maker.downcase.include?(query) })

    results.uniq!

    render json: results
  end

  def by_custom_camera_make
    @custom_make = params[:custom_camera_make]  
    @boards = Board.where(custom_camera_make: @custom_make)  
  end
  
  private
  
  def set_board
    @board = Board.find_by(id: params[:id])
  end
  
  def board_params
    params.require(:board).permit(:title, :body, :board_image_url, :camera_make, :camera_model, :custom_camera_make)
  end
end
  