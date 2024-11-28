class BoardsController < ApplicationController
    before_action :set_board, only: [:edit, :update, :show, :destroy] 

    def index
      @boards = @user.boards.order(created_at: :desc) # 新しい順番で並べる
    end
  
    def new
      @board = Board.new
      @camera_makes = ['Canon', 'Nikon', 'Sony', 'Panasonic']  # カメラメーカーのリスト

    end
  
def create
  @board = Board.new(board_params)
  @board.user = current_user # ログイン中のユーザーを設定

  if @board.save
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


    
# メーカーごとの投稿一覧
def by_camera_make
  @make = params[:make]          # camera_make
  @custom_make = params[:custom_camera_make]  # custom_camera_make

  # 文字列を初期化
  @page_title = if @make == 'その他' && @custom_make.present?
                  @custom_make # "あ" などのカスタムメーカー名を表示
                elsif @make == 'その他'
                  'その他'     # "その他"の投稿一覧
                else
                  @make        # 通常のメーカー名を表示
                end

  # camera_make が "その他" の場合、custom_camera_make をさらに絞り込む
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
   
      

  # 機種ごとの投稿一覧
  def by_camera_model
    @model = params[:model]


    @boards = Board.where(camera_model: @model)
                   .order(created_at: :desc)  # 必要に応じて並べ替えを追加
                   .page(params[:page])       # ページネーションを追加
                   .per(30)                   # 1ページあたりの表示数を30に設定
  end

  def edit
    @board = Board.find(params[:id])
    # カメラメーカーのリストを取得
    @camera_makes = Camera.distinct.pluck(:make)  # または、カメラメーカーのデータを取得
  end

  def search
    # params[:q]がnilでないことを確認し、デフォルト値を設定
    query = params.dig(:q, :query_cont) || ""
  
    # JSONリクエストの場合は、検索結果をJSON形式で返す
    if request.format.json?
      @q = Board.ransack(camera_make_or_camera_model_cont: query)
      @boards = @q.result(distinct: true).select(:id, :camera_make, :camera_model)

      # 結果があればJSONで返す
      render json: @boards.map { |item| { name: "#{item.camera_make} #{item.camera_model}" } }
    else
      # HTMLリクエストの場合、通常通りビューを返す
      @q = Board.ransack(camera_make_or_camera_model_cont: query)
      @boards = @q.result(distinct: true).includes(:user, :camera).order(created_at: :desc).page(params[:page]).per(30)
    end
  end

  def autocomplete
    type = params[:type]
    query = params[:query].downcase # 入力値を小文字に変換
  
    # 固定のカメラメーカーリスト（これを検索結果に追加）
    fixed_makers = ['Canon', 'Nikon', 'Sony', 'Fujifilm', 'Panasonic', 'Olympus', 'Ricoh', 'Casio', 'Minolta', 'Leica', 'Pentax', 'Kodak', 'Samsung', 'Vivitar', 'Toshiba', 'Yashica', 'Konica', 'Agfa', 'Zenit', 'Voigtländer', 'Polaroid', 'Rollei', 'Minox']
    
    # カメラメーカーとモデルの検索結果を格納する配列
    make_results = []
    model_results = []
  
    # カメラメーカーの検索（部分一致）
    make_results = Board.where('LOWER(camera_make) LIKE ? AND camera_make != ?', 
                                "%#{query}%", "不明")
                         .pluck(:camera_make)
                         .uniq
  
    # カメラモデルの検索（部分一致）
    model_results = Board.where('LOWER(camera_model) LIKE ? AND camera_make != ?', 
                                 "%#{query}%", "不明")
                          .pluck(:camera_model)
                          .uniq
  
    # 結果を結合し、固定のメーカーも追加
    results = make_results + model_results
    results.concat(fixed_makers.select { |maker| maker.downcase.include?(query) })
  
    # 重複を削除
    results.uniq!
  
    # JSONレスポンスとして返す
    render json: results
  end

  def by_custom_camera_make
    @custom_make = params[:custom_camera_make]  # URLからカスタムメーカー名を受け取る
    @boards = Board.where(custom_camera_make: @custom_make)  # カスタムメーカーでフィルタリング
  end
  

    private
  
    def set_board
      @board = Board.find(params[:id])
    end
  
    def board_params
      params.require(:board).permit(:title, :body, :board_image, :camera_make, :camera_model, :custom_camera_make)
    end
  end
  