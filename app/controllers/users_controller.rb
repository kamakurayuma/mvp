class UsersController < ApplicationController
    skip_before_action :require_login, only: %i[new create]
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        auto_login(@user)
        redirect_to root_path, success: '登録が完了しました'
      else
        flash.now[:danger] = 'ユーザー登録に失敗しました'
        render :new, status: :unprocessable_entity
      end
    end

    def show
        @user = User.find(params[:id]) 
        @boards = @user.boards.order(created_at: :desc).page(params[:page]).per(30)
    end 
  
    private
  
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :avatar_url)
    end
end