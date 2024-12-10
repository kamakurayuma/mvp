class UserSessionsController < ApplicationController
    skip_before_action :require_login, only: %i[new create]
  
    def new
      @user = User.new
    end
  
    def create
      @user = login(params[:email], params[:password])
    
      if @user
        redirect_to root_path, success: 'ログインしました'
      else
        @user = User.new(email: params[:email]) # ユーザー名を保持するための新しいオブジェクトを作成
        @user.errors.add(:base, 'メールアドレスまたはパスワードが無効です。') # エラーメッセージを追加
        flash.now[:danger] = 'ログインに失敗しました'
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      logout
      redirect_to root_path, status: :see_other, success: 'ログアウトしました'
    end
end