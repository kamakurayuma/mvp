class ProfilesController < ApplicationController
    before_action :set_user, only: %i[edit update]

    def edit
      @user = current_user
    end
  
def update
  # avatarのURLが含まれている場合に処理を追加
  if params[:user][:avatar].present?
    @user.avatar = params[:user][:avatar]
  end

  if @user.update(user_params)
    redirect_to profile_path, success: 'プロフィールを更新しました'
  else
    flash.now['danger'] = 'プロフィールを更新できませんでした'
    render :edit, status: :unprocessable_entity
  end
end

  
    def show
        @user = current_user
        @boards = @user.boards.order(created_at: :desc).page(params[:page]).per(30)
    end
  
    private
  
    def set_user
      @user = User.find(current_user.id)
    end
  
    def user_params
      params.require(:user).permit(:email, :user_name, :avatar, :avatar_cache, :bio, :avatar_url)
    end

    def profile_params
      params.require(:user).permit(:avatar, :user_name, :bio, :email)
    end
    
  end