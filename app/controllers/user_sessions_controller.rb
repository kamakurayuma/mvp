class UserSessionsController < ApplicationController
    include UserSessionsHelper
    skip_before_action :require_login, only: %i[new create]
  
    def new
      @user = User.new
    end
  
    def create
      @user = login(params[:email], params[:password]) 

      if @user
        if params[:remember_me] == '1'
          remember(@user)
        else
          forget(@user)
        end
        redirect_to root_path, success: 'ログインしました'
      else
        @user = User.new(email: params[:email]) 
        @user.errors.add(:base, 'メールアドレスまたはパスワードが無効です。') 
        flash.now[:danger] = 'ログインに失敗しました'
        render :new, status: :unprocessable_entity
      end
    end
     
    def destroy
      log_out if logged_in?
      redirect_to root_path, status: :see_other, success: 'ログアウトしました'
    end
end