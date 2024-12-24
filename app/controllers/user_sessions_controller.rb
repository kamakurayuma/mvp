class UserSessionsController < ApplicationController
    include UserSessionsHelper
    skip_before_action :require_login, only: %i[new create]
  
    def new
      @user = User.new
    end
  
    def create
      @user = login(params[:email], params[:password]) # 現在のログイン処理
      
      # ユーザーが認証された場合
      if @user
        # ユーザーがログインした際、remember_me チェックが入っている場合は永続的セッションを作成
        if params[:remember_me] == '1'
          remember(@user)
        else
          forget(@user)
        end
        redirect_to root_path, success: 'ログインしました'
      
      # ユーザーが認証されなかった場合
      else
        @user = User.new(email: params[:email]) # 認証に失敗したときは新しいオブジェクトを作成
        @user.errors.add(:base, 'メールアドレスまたはパスワードが無効です。') # エラーメッセージを追加
        flash.now[:danger] = 'ログインに失敗しました'
        render :new, status: :unprocessable_entity
      end
    end
    
  
    def destroy
      log_out if logged_in?
      redirect_to root_path, status: :see_other, success: 'ログアウトしました'
    end
end